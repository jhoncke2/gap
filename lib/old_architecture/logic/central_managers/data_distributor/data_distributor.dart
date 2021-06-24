import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/commented_image.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/data/models/commented_image_model.dart';
import 'package:gap/old_architecture/errors/logic/nav_obstruction_error.dart';
import 'package:gap/old_architecture/errors/services/service_status_err.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/index_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/preloaded_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/central_config/bloc_providers_creator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/errors/storage/app_never_runned.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/helpers/painter_to_image_converter.dart';
import 'package:gap/old_architecture/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/native_connectors/gps.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;

class DataDistributor{

  final UseCaseErrorHandler errorHandler = sl();
  final CentralSystemRepository centralSystemRepository = sl();
  final UserRepository userRepository = sl();
  final ProjectsRepository projectsRepository = sl();
  final VisitsRepository visitsRepository = sl();
  final FormulariosRepository formulariosRepository = sl();
  final PreloadedRepository preloadedRepository = sl();
  final IndexRepository indexRepository = sl();
  final CommentedImagesRepository commentedImagesRepository = sl();

  static final Map<BlocName, Bloc> blocsAsMap = BlocProvidersCreator.blocsAsMap;
  final Map<BlocName, ChangeNotifier> singletonesAsMap = BlocProvidersCreator.singletonesAsMap;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs = {};

  final UserOldBloc userB = blocsAsMap[BlocName.User];
  final ProjectsOldBloc projectsB =  blocsAsMap[BlocName.Projects];
  final VisitsOldBloc visitsB = blocsAsMap[BlocName.Visits];
  final FormulariosOldBloc formsB = blocsAsMap[BlocName.Formularios];
  final ChosenFormBloc chosenFormB = blocsAsMap[BlocName.ChosenForm];
  final FirmPaintBloc firmPaintB = blocsAsMap[BlocName.FirmPaint];
  final IndexOldBloc indexB = blocsAsMap[BlocName.Index];
  final CommentedImagesBloc commImgsB = blocsAsMap[BlocName.CommentedImages];

  Future<void> logout()async{
    await _setFirstTimeRunned();
  }

  Future updateFirstInitialization()async{
    final eitherAlreadyRunned = await errorHandler.executeFunction<bool>(
      () => centralSystemRepository.getAppRunnedAnyTime()
    );
    await eitherAlreadyRunned.fold((_){

    }, (alreadyRunned)async{
      if(!alreadyRunned){
        await centralSystemRepository.setAppRunnedAnyTime();
        throw AppNeverRunnedErr();
      }
    });
  }

  Future<void> _setFirstTimeRunned()async{
    await StorageConnectorOldSingleton.storageConnector.deleteAll();
    await UserStorageManager.setFirstTimeRunned();
  }

  Future doInitialConfig()async{
    userB.add(ChangeLoginButtopnAvaibleless(isAvaible: false));
    final result = await errorHandler.executeFunction<void>(
      () => userRepository.reLogin()
    );
    userB.add(ChangeLoginButtopnAvaibleless(isAvaible: true));
    result.fold((failure){
      throw UnfoundStorageElementErr(elementType: StorageElementType.AUTH_TOKEN);
    }, (r){
      //TODO: Implementar preloadedData sending
    });
  }

  Future<void> updateAccessToken(String accessToken)async{}

  Future login(Map<String, dynamic> loginInfo)async{
    if(loginInfo['type'] == 'first_login'){
      userB.add(ChangeLoginButtopnAvaibleless(isAvaible: false));
      final User user = User(email: loginInfo['email'], password: loginInfo['password']);
      final eitherLogin = await errorHandler.executeFunction<void>(
        () => userRepository.login(user)
      );
      await eitherLogin.fold((failure){
        String message;
        if(failure is ServerFailure)
          message = failure.message;
        throw ServiceStatusErr(extraInformation: 'login', message: message);
      }, (_)async{
        //TODO: Quitar cuando no se necesite más
        await errorHandler.executeFunction<void>(() => centralSystemRepository.setAppRunnedAnyTime());
        userB.add(ChangeLoginButtopnAvaibleless(isAvaible: true));
      });
    }else{
      final eitherRelogin = await errorHandler.executeFunction<void>(
        () => userRepository.reLogin()
      );
      eitherRelogin.fold((_){
        throw ServiceStatusErr(extraInformation: 'login');
      }, (_){
        userB.add(ChangeLoginButtopnAvaibleless(isAvaible: true));
      });
    }
  }

  Future<void> updateProjects()async{
    projectsB.add(ResetProjects());
    final Either<Failure, List<Project>> eitherProjects = await errorHandler.executeFunction<List<Project>>(
      () => projectsRepository.getProjects()
    );
    eitherProjects.fold((l)async{
      //TODO: Implementar manejo de error de conexión
      dialogs.showBlockedDialog(CustomNavigatorImpl.navigatorKey.currentContext, 'Ocurrió un error con los datos de los proyectos');
    }, (projects){
      List<ProjectOld> oldProjects = projects.map((p) => ProjectOld(id: p.id, nombre: p.nombre, visits: [])).toList();
      projectsB.add(SetProjects(projects: oldProjects));  
      //UploadedBlocsData.dataContainer[NavigationRoute.Projects] = projects;
    });
  }

  Future<void> updateChosenProject(ProjectOld projectOld)async{
    projectsB.add(ResetProjects());
    final ProjectModel project = ProjectModel(id: projectOld.id, nombre: projectOld.nombre);
    final eitherResult = await errorHandler.executeFunction(
      () => projectsRepository.setChosenProject(project)
    );
    eitherResult.fold((l){
      //TODO: Implementar manejo de errores
    }, (r){
      final ProjectOld chosenProjectOld = ProjectOld(id: project.id, nombre: project.nombre, visits: []);
      projectsB.add(ChooseProject(chosenOne: chosenProjectOld));
    });
  }

  Future<void> updateVisits()async{
    projectsB.add(ResetProjects());
    final eitherVisits = await errorHandler.executeFunction<List<Visit>>(() => visitsRepository.getVisits());
    eitherVisits.fold((failure){
      //TODO: Implementar manejo de errores
    }, (visits){
      final List<VisitOld> visitsOld = visits.map((v) => VisitOld.fromNewVisit(v)).toList();
      visitsB.add(SetVisits(visits: visitsOld));
    });
  }

  VisitModel _getVisitFromVisitOld(VisitOld vO)=>VisitModel(
    id: vO.id,
    formularios: [],
    completo: 
    vO.completo, 
    date: vO.date,
    sede: SedeModel(id: vO.sede.id, nombre: vO.sede.nombre),
    hasMuestreo: vO.hasMuestreo??false,
    //**************************************** */
    //No se puede utilizar este método porque no funciona la parte de los firmers
    firmers: []
  );
  
  Future<void> updateChosenVisit(VisitOld visitOld)async{
    visitsB.add(ResetVisits());
    final VisitModel chosenVisit = _getVisitFromVisitOld(visitOld);
    final eitherChooseResult = await errorHandler.executeFunction<void>(() => visitsRepository.setChosenVisit(chosenVisit));
    eitherChooseResult.fold((failure){
      //TODO: Implementar manejo de errores
    }, (_){
      visitsB.add(ChooseVisit(chosenOne: visitOld));
      //UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visitOld;
    });
  }

  @protected
  Future addChosenVisitToBloc(VisitOld visit)async{
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: visit);
    blocsAsMap[BlocName.Visits].add(cvEvent);
    //UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  Future<void> updateFormularios()async{
    visitsB.add(ChangeChosenVisitBlocking(isBlocked: true));
    final eitherFormularios = await errorHandler.executeFunction<List<Formulario>>(() =>  formulariosRepository.getFormularios());
    eitherFormularios.fold((failure){
      //TODO: Implementar manejo de errores
    }, (formularios){
      List<FormularioOld> formulariosOld = formularios.map((f) => FormularioOld.fromFormularioNew(f)).toList();
      formsB.add(SetForms(forms: formulariosOld));
      formsB.add(ChangeFormsAreBlocked(areBlocked: false));
    });
  }
  
  Future<void> updateChosenForm(List data)async{
    formsB.add(ChangeFormsAreBlocked(areBlocked: true));
    final FormularioModel chosenForm = _getFormularioFromFormularioOld(data[0]);
    final eitherChoose = await errorHandler.executeFunction(() => formulariosRepository.setChosenFormulario(chosenForm));
    indexB.add(ResetAllOfIndex());
    await eitherChoose.fold((l)async{
      formsB.add(ChangeFormsAreBlocked(areBlocked: false));
      throw NavObstructionErr(message: 'Ocurrió un error con el formulario');
      //TODO: Implementar manejo de errores
    }, (_)async{
      await _updateChosenFormFromRepository(data[1]);
    });
  }

  Future<void> _updateChosenFormFromRepository(bool takeInitialPosition)async{
    final eitherUpdatedChosenForm = await errorHandler.executeFunction<Formulario>(() => formulariosRepository.getChosenFormulario());
    await eitherUpdatedChosenForm.fold((l)async{
      formsB.add(ChangeFormsAreBlocked(areBlocked: false));
      throw NavObstructionErr(message: 'Ocurrió un problema al cargar la información del formulario');
      //TODO: Implementar manejo de errores
    }, (updatedChosenForm)async{
      if(updatedChosenForm.campos.isEmpty){
        formsB.add(ChangeFormsAreBlocked(areBlocked: false));
        throw NavObstructionErr(message: 'El formulario no tiene campos');
      }
        
      await _manageUpdatedChosenForm(updatedChosenForm, takeInitialPosition);
    });
  }

  Future<void> _manageUpdatedChosenForm(FormularioModel updatedChosenForm, bool takeInitialPosition)async{
    final FormularioOld updatedChosenFormOld = FormularioOld.fromFormularioNew(updatedChosenForm);
    if(takeInitialPosition){
      await addInitialPosition(updatedChosenFormOld);
      final eitherSetInitialPosition = await errorHandler.executeFunction(
        () => formulariosRepository.setInitialPosition(CustomPositionModel(
          latitude: updatedChosenFormOld.initialPosition.latitude,
          longitude: updatedChosenFormOld.initialPosition.longitude
        ))
      );
      eitherSetInitialPosition.fold((l){
        formsB.add(ChangeFormsAreBlocked(areBlocked: false));
        throw NavObstructionErr(message: 'Ocurrión un problema al enviar la posición geográfica.');
        //TODO: Implementar manejo de errores
      }, (_){ 
        //TODO: Implementar método
      });
    }
    formsB.add(ChooseForm(chosenOne: updatedChosenFormOld));
    await _chooseBlocMethodByChosenFormStep(updatedChosenFormOld);
    formsB.add(ChangeFormsAreBlocked(areBlocked: false));
    
  }

  FormularioModel _getFormularioFromFormularioOld(FormularioOld old)=>FormularioModel(
    id: old.id,
    nombre: old.name,
    completo: old.completo,
    initialDate: old.date,
    campos: old.campos,
    formStepIndex: old.formStepIndex,
    firmers: old.firmers.map((fO) => FirmerModel(
      id: fO.id, 
      name: fO.name, 
      identifDocumentType: fO.identifDocumentType, 
      identifDocumentNumber: fO.identifDocumentNumber,
      cargo: fO.cargo,
      firm: fO.firm
    )).toList(),
    initialPosition: old.initialPosition == null? null : CustomPositionModel(latitude: old.initialPosition.latitude, longitude: old.initialPosition.longitude),
    finalPosition: old.finalPosition == null? null : CustomPositionModel(latitude: old.finalPosition.latitude, longitude: old.finalPosition.longitude)
  );

  @protected
  Future<FormularioOld> getUpdatedChosenForm(FormularioOld form)async{
    return form;
  }

  @protected
  Future addInitialPosition(FormularioOld form)async{
    final Position currentPosition = await GPSOld.gpsPosition;
    form.initialPosition = currentPosition;
  }

  Future _chooseBlocMethodByChosenFormStep(FormularioOld form)async{
    switch(form.formStep){ 
      case FormStep.WithoutForm:
        break;
      case FormStep.OnFormFillingOut:
        _initOnFormFillingOut(form);
        break;
      case FormStep.OnFormReading:
        _initOnFormReading(form);
        break;
      case FormStep.OnFirstFirmerInformation:
        _initOnFirstFirmerInformation();
        break;
      case FormStep.OnFirstFirmerFirm:
        _initOnFirstFirmerFirm(form);
        break;
      case FormStep.OnSecondaryFirms:
        _onSecondaryFirms(form);
        break;
      case FormStep.Finished:
        _onFormFinished(form);
        break;
    }
  }

  void _initOnFormFillingOut(FormularioOld form){
    chosenFormB.add(InitFormFillingOut(formulario: form, onEndEvent: _changeIndexBlocNPages));
  }

  void _initOnFormReading(FormularioOld form){
    chosenFormB.add(InitFormReading(formulario: form, onEndEvent: _changeIndexBlocNPages));
  }

  void _changeIndexBlocNPages(int formFieldsPages){
    indexB.add(ChangeNPages(nPages: formFieldsPages, onEnd: _updateFormFieldsPage));
  }

  void _updateFormFieldsPage(int currentPage){
    chosenFormB.add(UpdateFormField(pageOfFormField: currentPage, onEndFunction: _onUpdateFormFields));
  }

  Future _onUpdateFormFields(bool pageOfFormFieldsIsFilled)async{
    _changeIndexActivation(pageOfFormFieldsIsFilled);
  }

  void _changeIndexActivation(bool isActive)async{
    indexB.add(ChangeSePuedeAvanzar(sePuede: isActive));
  }

  void _initOnFirstFirmerInformation(){
    chosenFormB.add(InitFirstFirmerFillingOut());
    indexB.add(ResetAllOfIndex());
  }

  void _initOnFirstFirmerFirm(form){
    chosenFormB.add(InitFirstFirmerFirm());
  }

  void _onSecondaryFirms(FormularioOld form){
    chosenFormB.add(InitFirmsFillingOut());
  }

  void _onFormFinished(FormularioOld form){
    chosenFormB.add(InitFormFinishing(form: form, onEnd: _changeIndexBlocNPages));
  }

  Future updateFormFieldsPage()async{
    final int indexPage = indexB.state.currentIndexPage;
    _updateFormFieldsPage(indexPage);
  }

  Future endFormFillingOut()async{
    final FormularioOld chosenFormOld = formsB.state.chosenForm;
    await _addFinalPosition(chosenFormOld);
    deleteNullFirmersFromForm(chosenFormOld);
    //await updateChosenFormInStorage(chosenForm);
    final eitherSetFinalPosition = await errorHandler.executeFunction<void>(
      () => formulariosRepository.setFinalPosition(CustomPositionModel(
        latitude: chosenFormOld.finalPosition.latitude, 
        longitude: chosenFormOld.finalPosition.longitude
      ))
    );
    eitherSetFinalPosition.fold((_){
      //TODO: Implementar manejo de errores
    }, (_){

    });
    FormularioModel formulario = _getFormularioFromFormularioOld(chosenFormOld);
    final eitherSetCampos = await errorHandler.executeFunction<void>(() => formulariosRepository.setCampos(formulario));
    await eitherSetCampos.fold((_)async{
      //TODO: Implementar manejo de errores
      await dialogs.showTemporalDialog('Ocurrió un error al enviar los campos');
    }, (_)async{
      chosenFormOld.advanceInStep();
      _initOnFormReading(chosenFormOld);
      await dialogs.showTemporalDialog('Visualiza tus resupestas antes de firmar');
      indexB.add(ChangeIndexPage(newIndexPage: 0));
    });
  }

  @protected
  Future _addFinalPosition(FormularioOld form)async{
    final Position currentPosition = await GPSOld.gpsPosition;
    form.finalPosition = currentPosition;
  }

  @protected
  Future updateChosenFormInStorage(FormularioOld form)async{
    deleteNullFirmersFromForm(form);  
    await ChosenFormStorageManager.setChosenForm(form);
    await PreloadedFormsStorageManager.setPreloadedForm(form, visitsB.state.chosenVisit.id);
  }

  @protected
  void deleteNullFirmersFromForm(FormularioOld form){
    List<PersonalInformationOld> firmers = form.firmers.where((f){
      return ![f.firm, f.name, f.identifDocumentType, f.identifDocumentNumber].contains(null);
    }).toList();
    form.firmers = firmers;
  }
  
  Future initFirstFirmerFillingOut()async{
    final FormularioOld chosenFormOld = formsB.state.chosenForm;
    _initOnFirstFirmerInformation();
    chosenFormOld.advanceInStep();
    final FormularioModel chosenForm = _getFormularioFromFormularioOld(chosenFormOld);
    final eitherUpdateForm = await errorHandler.executeFunction<void>(() => formulariosRepository.setChosenFormulario(chosenForm));
    eitherUpdateForm.fold((l){
      //TODO: Implementar manejo de errores
    }, (_){
      
    });
    //await updateChosenFormInStorage(chosenForm);
  }

  Future initFirstFirmerFirm()async{
    final FormularioOld chosenForm = formsB.state.chosenForm;
    chosenForm.advanceInStep();
    _addNewFirmer(InitFirstFirmerFirm());
    //await updateChosenFormInStorage(chosenForm);
  }

  Future updateFirmers()async{
    final FormularioOld chosenFormOld = formsB.state.chosenForm;
    await _updateFirmersInForm(chosenFormOld);
    _advanceInStepIfIsInFirstFirmerFirm(chosenFormOld);
    //await updateChosenFormInStorage(chosenForm);
    final FormularioModel chosenFormulario = _getFormularioFromFormularioOld(chosenFormOld);
    final eitherSetFirmer = await errorHandler.executeFunction<void>(() => formulariosRepository.setFirmer(chosenFormulario.firmers.last));
    await eitherSetFirmer.fold((failure){
      //TODO: Implementar manejo de errores
      dialogs.showTemporalDialog('Ocurrió un error con el envío de la firma');
    }, (r)async{
      chosenFormulario.firmers.removeAt(0);
      final eitherUpdateFormulario = await errorHandler.executeFunction<void>(() => formulariosRepository.setChosenFormulario(chosenFormulario));
      eitherUpdateFormulario.fold((failure){
        //TODO: Implementar manejo de errores
        dialogs.showTemporalDialog('Ocurrió un error con la actualización de las firmas del formulario');
      }, (_)async{
        chosenFormB.add(UpdateFirmerPersonalInformation(firmer: chosenFormOld.firmers.last.clone()));
        _addNewFirmer(InitFirmsFillingOut());
      });
    });
  }

  Future _updateFirmersInForm(FormularioOld form)async{
    form.firmers.add( chosenFormB.state.firmers.last.clone() );
    final File currentFirmFile = await PainterToImageConverter.createFileFromFirmPainter(firmPaintB.state.firmPainter, form.firmers.length-1);
    form.firmers.last.firm = currentFirmFile;
  }

  void _advanceInStepIfIsInFirstFirmerFirm(FormularioOld form){
    if(form.formStep == FormStep.OnFirstFirmerFirm)
      form.advanceInStep();
  }

  void _addNewFirmer(ChosenFormEvent cfEvent){
    chosenFormB.add(cfEvent);
    firmPaintB.add(ResetFirmPaint());
  }

  Future endAllFormProcess()async{
    chosenFormB.add(InitFirmsFinishing());
    final FormularioOld chosenForm = formsB.state.chosenForm;
    chosenForm.formStep = FormStep.Finished;
    //await updateFirmers();
    //await _updateFirmersInForm(chosenForm);
    await formulariosRepository.endChosenFormulario();
    //await updateChosenFormInStorage(chosenForm);
    chosenFormB.add(ResetChosenForm());
    indexB.add(ResetAllOfIndex());  
  }
  
  Future updateCommentedImages()async{
    indexB.add(ResetAllOfIndex());
    commImgsB.add(InitImagesCommenting());
    visitsB.add(ChangeChosenVisitBlocking(isBlocked: true));
    
    final eitherCommentedImages = await errorHandler.executeFunction<List<SentCommentedImage>>(
      () => commentedImagesRepository.getCommentedImages()
    );
    eitherCommentedImages.fold((l){
      //TODO: Implementar manejo de errores
    }, (commentedImages){
      final List<SentCommentedImageOld> commentedImagesOld = commentedImages.map((cI) => SentCommentedImageOld(
        url: cI.imgnUrl,
        commentary: cI.commentary??''
      )).toList();
      if(commentedImagesOld.isEmpty){
        commImgsB.add(InitImagesCommenting());
      }else{
        commImgsB.add(InitSentCommImgsWatching(sentCommentedImages: commentedImagesOld, onEnd: changeNPagesToIndex));
      }
    });
    final List<UnSentCommentedImageOld> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    _addCommentedImagesToBlocIfExistsInStorage(commentedImages);
  }
  

  void _addCommentedImagesToBlocIfExistsInStorage(List<UnSentCommentedImageOld> commentedImages)async{
    if(commentedImages.length > 0){
      _addCommentedImagesToBloc(commentedImages);
    } 
  }

  void _addCommentedImagesToBloc(List<UnSentCommentedImageOld> commentedImages)async{
    final CommentedImagesBloc ciBloc = blocsAsMap[BlocName.CommentedImages];
    final SetCommentedImages sciEvent = SetCommentedImages(dataType: CmmImgDataType.UNSENT, commentedImages: commentedImages);
    ciBloc.add(sciEvent);
  }

  void addCurrentPhotosToCommentedImages(){
    final CommentedImagesBloc commImagesBloc = blocsAsMap[BlocName.CommentedImages];
    final IndexOldBloc indexBloc = blocsAsMap[BlocName.Index];
    final ImagesOldBloc imgsBloc = blocsAsMap[BlocName.Images];
    _addCurrentPhotosToCommentedImages(commImagesBloc, indexBloc, imgsBloc);
    _resetFotosPorAgregar(imgsBloc);
  }

  void _addCurrentPhotosToCommentedImages(CommentedImagesBloc commImagesBloc, IndexOldBloc indexBloc, ImagesOldBloc imgsBloc){
    final AddImages addImagesEvent = AddImages(images: imgsBloc.state.currentPhotosToSet, onEnd: changeNPagesToIndex);
    commImagesBloc.add(addImagesEvent);
  }

  @protected
  void changeNPagesToIndex(){
    final CommentedImagesState commImgsState = commImgsB.state;
    final int newIndexNPages = commImgsState.nPaginasDeCommImages;
    final ChangeNPages changesNPagesEvent = ChangeNPages(nPages: newIndexNPages);
    indexB.add(changesNPagesEvent);
  }

  void _resetFotosPorAgregar(ImagesOldBloc imgsBloc){
    final ResetImages resetAllEvent = ResetImages();
    imgsBloc.add(resetAllEvent);
  }

  Future endCommentedImagesProcess()async{
    visitsB.add(ChangeChosenVisitBlocking(isBlocked: false));
    commImgsB.add(ChangeCommentedImagesLoading(isLoading: true));
    indexB.add(ResetAllOfIndex());
    if(commImgsB.state.dataType == CmmImgDataType.UNSENT){
      final List<CommentedImageOld> commImgsOld = commImgsB.state.allCommentedImages.toList();
      final List<UnSentCommentedImageModel> commentedImages = commImgsOld.map((ciO) => UnSentCommentedImageModel(
        image: (ciO as UnSentCommentedImageOld).image,
        commentary: ciO.commentary
      )).toList();
      final eitherSetCommImgs = await errorHandler.executeFunction<void>(() => commentedImagesRepository.setCommentedImages(commentedImages));
      eitherSetCommImgs.fold((l){
        //TODO: Implementar manejo de errores
      }, (r){
        //commImgsB.add(ChangeCommentedImagesLoading(isLoading: false));
      });
    }
    else
      commImgsB.add(ResetCommentedImages());
    
    if(commImgsB.state.dataType == CmmImgDataType.UNSENT){
      //await updateProjects();
      await updateVisits();
    }
  }

  Future resetChosenProject()async{
    projectsB.add(ResetProjects());
    //await ProjectsStorageManager.removeChosenProject();
    await updateProjects();
  }

  Future resetVisits()async{
    visitsB.add(ResetVisits());
    final eitherChosenProject = await errorHandler.executeFunction<Project>(() => projectsRepository.getChosenProject());
    eitherChosenProject.fold((l){

    }, (chosenProject){
      final chosenProjectOld = ProjectOld(id: chosenProject.id, nombre: chosenProject.nombre, visits: []);
      projectsB.add(ChooseProject(chosenOne: chosenProjectOld));
    });
    //await VisitsStorageManager.removeVisits();
  }

  Future resetChosenVisit()async{
    //await CommentedImagesStorageManager.removeCommentedImages();
    visitsB.add(ResetVisits());
    commImgsB.add(ResetCommentedImages());
    await updateVisits();
    
    //await VisitsStorageManager.removeChosenVisit();
  }

  Future resetForms()async{
    formsB.add(ResetForms());
    final eitherChosenVisit = await errorHandler.executeFunction<Visit>(() => visitsRepository.getChosenVisit( ));
    await eitherChosenVisit.fold((l){
      
    }, (visit)async{
      VisitOld chosenVisitOld = VisitOld.fromNewVisit(visit);
      await updateChosenVisit(chosenVisitOld);
    });
  }

  Future resetChosenForm()async{
    formsB.add(ChangeFormsAreBlocked(areBlocked: false));
    indexB.add(ResetAllOfIndex());
  }

  Future resetCommentedImages()async{
  }
}

class UploadedBlocsData{
  static final Map<NavigationRoute, dynamic> dataContainer = {};
}