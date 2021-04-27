import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
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
import 'package:gap/old_architecture/logic/central_managers/preloaded_storage_to_services.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:gap/old_architecture/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;
import 'package:gap/old_architecture/native_connectors/gps.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';


abstract class DataDistributor{

  final UserRepository userRepository = GetItContainer.sl();
  final ProjectsRepository projectsRepository = GetItContainer.sl();
  final VisitsRepository visitsRepository = GetItContainer.sl();
  final FormulariosRepository formulariosRepository = GetItContainer.sl();
  final PreloadedRepository preloadedRepository = GetItContainer.sl();
  final IndexRepository indexRepository = GetItContainer.sl();
  //TODO: Testear/Crear
  final CommentedImagesRepository commentedImagesRepository = GetItContainer.sl();


  static final Map<BlocName, Bloc> blocsAsMap = BlocProvidersCreator.blocsAsMap;
  final Map<BlocName, ChangeNotifier> singletonesAsMap = BlocProvidersCreator.singletonesAsMap;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs = {};

  final UserBloc userB = blocsAsMap[BlocName.User];
  final ProjectsBloc projectsB =  blocsAsMap[BlocName.Projects];
  final VisitsBloc visitsB = blocsAsMap[BlocName.Visits];
  final FormulariosBloc formsB = blocsAsMap[BlocName.Formularios];
  final ChosenFormBloc chosenFormB = blocsAsMap[BlocName.ChosenForm];
  final FirmPaintBloc firmPaintB = blocsAsMap[BlocName.FirmPaint];
  final IndexBloc indexB = blocsAsMap[BlocName.Index];
  final CommentedImagesBloc commImgsB = blocsAsMap[BlocName.CommentedImages];

  Future updateFirstInitialization()async{
    final bool alreadyRunned = await UserStorageManager.alreadyRunnedApp();
    if(!alreadyRunned){
      await StorageConnectorOldSingleton.storageConnector.deleteAll();
      await UserStorageManager.setFirstTimeRunned();
      throw AppNeverRunnedErr();
    }
  }

  Future doInitialConfig()async{
    userB.add(ChangeLoginButtopnAvaibleless(isAvaible: false));
    final result = await userRepository.reLogin();
    userB.add(ChangeLoginButtopnAvaibleless(isAvaible: true));
    result.fold((failure){
      throw UnfoundStorageElementErr(elementType: StorageElementType.AUTH_TOKEN);
    }, (r){
      //TODO: Implementar preloadedData sending
    });
    //final accessToken = await UserStorageManager.getAccessToken();
    //if(accessToken == null)
      //throw UnfoundStorageElementErr(elementType: StorageElementType.AUTH_TOKEN);
    //await updateAccessToken(accessToken);
    //await PreloadedStorageToServices.sendPreloadedStorageDataToServices();
  }

  Future<void> updateAccessToken(String accessToken)async{}

  Future login(Map<String, dynamic> loginInfo)async{
    if(loginInfo['type'] == 'first_login'){
      final User user = User(email: loginInfo['email'], password: loginInfo['password']);
      await userRepository.login(user);
    }else
      await userRepository.reLogin();
  }

  Future<void> updateProjects()async{
    final Either<Failure, List<Project>> eitherProjects = await projectsRepository.getProjects();
    eitherProjects.fold((l)async{
      //TODO: Implementar manejo de error de conexión
      dialogs.showBlockedDialog(CustomNavigator.navigatorKey.currentContext, 'Ocurrió un error con los datos de los proyectos');
    }, (projects){
      List<ProjectOld> oldProjects = projects.map((p) => ProjectOld(id: p.id, nombre: p.nombre, visits: [])).toList();
      projectsB.add(SetProjects(projects: oldProjects));  
      UploadedBlocsData.dataContainer[NavigationRoute.Projects] = projects;
    });
  }

  Future<void> updateChosenProject(ProjectOld projectOld)async{
    final ProjectModel project = ProjectModel(id: projectOld.id, nombre: projectOld.nombre);
    final eitherResult = await projectsRepository.setChosenProject(project);
    eitherResult.fold((l){
      //TODO: Implementar manejo de errores     
    }, (r){
      final ProjectOld chosenProjectOld = ProjectOld(id: project.id, nombre: project.nombre, visits: []);
      projectsB.add(ChooseProject(chosenOne: chosenProjectOld));
    });
    /*
    final List<ProjectOld> projects = UploadedBlocsData.dataContainer[NavigationRoute.Projects] ?? projectsB.state.projects;
    final List<ProjectOld> equalsUpdatedProjects = projects.where((element) => element.id == project.id).toList();
    final ProjectOld realProject = equalsUpdatedProjects.length > 0? equalsUpdatedProjects[0] : project;
    final ChooseProject cpEvent = ChooseProject(chosenOne: realProject);
    projectsB.add(cpEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = realProject;
    await ProjectsStorageManager.setChosenProject(realProject);
    */
  }

  Future<void> updateVisits()async{
    final eitherVisits = await visitsRepository.getVisits();
    eitherVisits.fold((failure){
      //TODO: Implementar manejo de errores
    }, (visits){
      final List<VisitOld> visitsOld = visits.map((v) => VisitOld.fromNewVisit(v)).toList();
      visitsB.add(SetVisits(visits: visitsOld));
      UploadedBlocsData.dataContainer[NavigationRoute.Visits] = visits;
    });
  }

  VisitModel _getVisitFromVisitOld(VisitOld vO)=>VisitModel(
    id: vO.id, 
    completo: 
    vO.completo, 
    date: vO.date, 
    sede: SedeModel(id: vO.sede.id, nombre: vO.sede.nombre),
  );
  
  Future<void> updateChosenVisit(VisitOld visitOld)async{
    final VisitModel chosenVisit = _getVisitFromVisitOld(visitOld);
    final eitherChooseResult = await visitsRepository.setChosenVisit(chosenVisit);
    eitherChooseResult.fold((failure){
      //TODO: Implementar manejo de errores
    }, (r){
      visitsB.add(ChooseVisit(chosenOne: visitOld));
      UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visitOld;
    });
    //await addChosenVisitToBloc(visit);
    //await VisitsStorageManager.setChosenVisit(visit);
    //UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  //TODO: Borrar en su desuso
  @protected
  VisitOld getUpdatedChosenVisit(VisitOld newChosenVisit){
    final List<VisitOld> visits = UploadedBlocsData.dataContainer[NavigationRoute.Visits];
    final List<VisitOld> updatedEqualsVisits = visits.where((element) => element.id == newChosenVisit.id).toList();
    return updatedEqualsVisits.length > 0? updatedEqualsVisits[0] : newChosenVisit;
  }

  @protected
  Future addChosenVisitToBloc(VisitOld visit)async{
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: visit);
    blocsAsMap[BlocName.Visits].add(cvEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  Future<void> updateFormularios()async{
    final eitherFormularios = await formulariosRepository.getFormularios();
    eitherFormularios.fold((failure){
      //TODO: Implementar manejo de errores
    }, (formularios){
      List<FormularioOld> formulariosOld = formularios.map((f) => FormularioOld.fromFormularioNew(f)).toList();
      formsB.add(SetForms(forms: formulariosOld));
      formsB.add(ChangeFormsAreBlocked(areBlocked: false));
    });
    
  }
  
  Future<void> updateChosenForm(FormularioOld formOld)async{
    final FormularioModel chosenForm = _getFormularioFromFormularioOld(formOld);
    final eitherChoose = await formulariosRepository.setChosenFormulario(chosenForm);
    indexB.add(ResetAllOfIndex());
    await eitherChoose.fold((l)async{
      //TODO: Implementar manejo de errores
    }, (_)async{
      await _updateChosenFormFromRepository(formOld);
    });
  }

  Future<void> _updateChosenFormFromRepository(FormularioOld formOld)async{
    final eitherUpdatedChosenForm = await formulariosRepository.getChosenFormulario();
    await eitherUpdatedChosenForm.fold((l)async{
      //TODO: Implementar manejo de errores
    }, (updatedChosenForm)async{
      await _manageUpdatedChosenForm(updatedChosenForm);
    });
  }

  Future<void> _manageUpdatedChosenForm(FormularioModel updatedChosenForm)async{
    final FormularioOld updatedChosenFormOld = FormularioOld.fromFormularioNew(updatedChosenForm);
    await addInitialPosition(updatedChosenFormOld);
    formsB.add(ChooseForm(chosenOne: updatedChosenFormOld));
    await _chooseBlocMethodByChosenFormStep(updatedChosenFormOld);
    formsB.add(ChangeFormsAreBlocked(areBlocked: false));
    final eitherSetInitialPosition = await formulariosRepository.setInitialPosition(CustomPositionModel(
      latitude: updatedChosenFormOld.initialPosition.latitude,
      longitude: updatedChosenFormOld.initialPosition.longitude
    ));
    eitherSetInitialPosition.fold((l){
      //TODO: Implementar manejo de errores
    }, (_){
      //TODO: Implementar método
    });
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
    final Position currentPosition = await GPS.gpsPosition;
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
    chosenFormB.add(UpdateFormField(pageOfFormField: 0, onEndFunction: _onUpdateFormFields));
  }

  Future _onUpdateFormFields(bool pageOfFormFieldsIsFilled)async{
    if(pageOfFormFieldsIsFilled)
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
    final eitherSetFinalPosition = await formulariosRepository.setFinalPosition(CustomPositionModel(
      latitude: chosenFormOld.finalPosition.latitude, 
      longitude: chosenFormOld.finalPosition.longitude
    ));
    eitherSetFinalPosition.fold((_){
      //TODO: Implementar manejo de errores
    }, (_){

    });
    FormularioModel formulario = _getFormularioFromFormularioOld(chosenFormOld);
    final eitherSetCampos = await formulariosRepository.setCampos(formulario);
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
    final Position currentPosition = await GPS.gpsPosition;
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
    final eitherUpdateForm = await formulariosRepository.setChosenFormulario(chosenForm);
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
    final eitherSetFirmer = await formulariosRepository.setFirmer(chosenFormulario.firmers.last);
    await eitherSetFirmer.fold((failure){
      //TODO: Implementar manejo de errores
      dialogs.showTemporalDialog('Ocurrió un error con el envío de la firma');
    }, (r)async{
      chosenFormulario.firmers.removeAt(0);
      final eitherUpdateFormulario = await formulariosRepository.setChosenFormulario(chosenFormulario);
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
    await _updateFirmersInForm(chosenForm);
    await updateChosenFormInStorage(chosenForm);
    chosenFormB.add(ResetChosenForm());
    indexB.add(ResetAllOfIndex());  
  }
  
  Future updateCommentedImages()async{
    commImgsB.add(InitImagesCommenting());
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
    final IndexBloc indexBloc = blocsAsMap[BlocName.Index];
    final ImagesBloc imgsBloc = blocsAsMap[BlocName.Images];
    _addCurrentPhotosToCommentedImages(commImagesBloc, indexBloc, imgsBloc);
    _resetFotosPorAgregar(imgsBloc);
  }

  void _addCurrentPhotosToCommentedImages(CommentedImagesBloc commImagesBloc, IndexBloc indexBloc, ImagesBloc imgsBloc){
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

  void _resetFotosPorAgregar(ImagesBloc imgsBloc){
    final ResetImages resetAllEvent = ResetImages();
    imgsBloc.add(resetAllEvent);
  }

  Future endCommentedImagesProcess()async{
    indexB.add(ResetAllOfIndex());
    if(commImgsB.state.dataType == CmmImgDataType.UNSENT){
      await updateProjects();
      await updateVisits();
    }
  }

  Future<void> addStorageDataToIndexBloc()async{
    final IndexBloc indexBloc = blocsAsMap[BlocName.Index];
    final IndexState indexConfig = await IndexStorageManager.getIndex();
    final int nPages = indexConfig.nPages;
    final ChangeNPages cnpEvent = ChangeNPages(nPages: nPages);
    indexBloc.add(cnpEvent);
    final int newIndexPage = indexConfig.currentIndexPage;
    final ChangeIndexPage ciEvent = ChangeIndexPage(newIndexPage: newIndexPage);
    indexBloc.add(ciEvent);
  }

  Future resetChosenProject()async{
    projectsB.add(ResetProjects());
    await ProjectsStorageManager.removeChosenProject();
    await updateProjects();
  }

  Future resetVisits()async{
    visitsB.add(ResetVisits());
    await VisitsStorageManager.removeVisits();
  }

  Future resetChosenVisit()async{
    await CommentedImagesStorageManager.removeCommentedImages();
    commImgsB.add(ResetCommentedImages());
    await VisitsStorageManager.removeChosenVisit();
  }

  Future resetForms()async{
    formsB.add(ResetForms());
    await updateProjects(); 
    //final ProjectOld chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    //await updateChosenProject(chosenProject);
    await updateVisits();
    //final VisitOld chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    //await updateChosenVisit(chosenVisit);
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