import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/storage/app_never_runned.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/helpers/painter_to_image_converter.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;
import 'package:gap/native_connectors/gps.dart';
import 'package:gap/native_connectors/storage_connector.dart';


abstract class DataDistributor{

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
      await StorageConnectorSingleton.storageConnector.deleteAll();
      await UserStorageManager.setFirstTimeRunned();
      throw AppNeverRunnedErr();
    }
  }

  Future doInitialConfig()async{

  }

  Future<void> updateAccessToken(String accessToken)async{}

  Future login(Map<String, dynamic> loginInfo)async{
  }

  Future<void> updateProjects()async{}

  Future<void> updateChosenProject(Project project)async{
    final List<Project> projects = UploadedBlocsData.dataContainer[NavigationRoute.Projects] ?? projectsB.state.projects;
    final List<Project> equalsUpdatedProjects = projects.where((element) => element.id == project.id).toList();
    final Project realProject = equalsUpdatedProjects.length > 0? equalsUpdatedProjects[0] : project;
    final ChooseProject cpEvent = ChooseProject(chosenOne: realProject);
    projectsB.add(cpEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = realProject;
    await ProjectsStorageManager.setChosenProject(realProject);
  }

  Future<void> updateVisits()async{}
  
  Future<void> updateChosenVisit(Visit visit)async{
    await addChosenVisitToBloc(visit);
    await VisitsStorageManager.setChosenVisit(visit);
    UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  @protected
  Visit getUpdatedChosenVisit(Visit newChosenVisit){
    final List<Visit> visits = UploadedBlocsData.dataContainer[NavigationRoute.Visits];
    final List<Visit> updatedEqualsVisits = visits.where((element) => element.id == newChosenVisit.id).toList();
    return updatedEqualsVisits.length > 0? updatedEqualsVisits[0] : newChosenVisit;
  }

  @protected
  Future addChosenVisitToBloc(Visit visit)async{
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: visit);
    blocsAsMap[BlocName.Visits].add(cvEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  Future<void> updateFormularios()async{
    formsB.add(ChangeFormsAreBlocked(areBlocked: false));
  }
  
  Future<void> updateChosenForm(Formulario form)async{
    //formsB.add(ChangeFormsAreBlocked(areBlocked: true));
    indexB.add(ResetAllOfIndex());
    formsB.add(ChooseForm(chosenOne: form));
    await ChosenFormStorageManager.setChosenForm(form);
    await _chooseBlocMethodByChosenFormStep(form);
    formsB.add(ChangeFormsAreBlocked(areBlocked: false));
    //formsB.add(ChangeFormsAreBlocked(areBlocked: false));
  }

  @protected
  Future<Formulario> getUpdatedChosenForm(Formulario form)async{
    return form;
  }

  @protected
  Future addInitialPosition(Formulario form)async{
    final Position currentPosition = await GPS.gpsPosition;
    form.initialPosition = currentPosition;
  }

  Future _chooseBlocMethodByChosenFormStep(Formulario form)async{
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

  void _initOnFormFillingOut(Formulario form){
    chosenFormB.add(InitFormFillingOut(formulario: form, onEndEvent: _changeIndexBlocNPages));
  }

  void _initOnFormReading(Formulario form){
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

  void _initOnFirstFirmerInformation(){
    chosenFormB.add(InitFirstFirmerFillingOut());
    indexB.add(ResetAllOfIndex());
  }

  void _initOnFirstFirmerFirm(form){
    chosenFormB.add(InitFirstFirmerFirm());
  }

  void _onSecondaryFirms(Formulario form){
    chosenFormB.add(InitFirmsFillingOut());
  }

  void _onFormFinished(Formulario form){
    chosenFormB.add(InitFormFinishing(form: form, onEnd: _changeIndexBlocNPages));
  }

  Future updateFormFieldsPage()async{
    final int indexPage = indexB.state.currentIndexPage;
    _updateFormFieldsPage(indexPage);
  }

  void _changeIndexActivation(bool isActive)async{
    indexB.add(ChangeSePuedeAvanzar(sePuede: isActive));
  }

  Future endFormFillingOut()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    //_initOnFirstFirmerInformation();
    await _addFinalPosition(chosenForm);
    chosenForm.advanceInStep();
    await updateChosenFormInStorage(chosenForm);
    _initOnFormReading(chosenForm);
    await dialogs.showTemporalDialog('Puedes visualizar tus resupestas antes de firmar');
  }

  @protected
  Future _addFinalPosition(Formulario form)async{
    final Position currentPosition = await GPS.gpsPosition;
    form.finalPosition = currentPosition;
  }

  @protected
  Future updateChosenFormInStorage(Formulario form)async{
    deleteNullFirmersFromForm(form);  
    await ChosenFormStorageManager.setChosenForm(form);
    await PreloadedFormsStorageManager.setPreloadedForm(form, visitsB.state.chosenVisit.id);
  }

  @protected
  void deleteNullFirmersFromForm(Formulario form){
    //TODO: Decidir si es necesario revisar todos los cuatro campos de la firma o solo los más importantes
    List<PersonalInformation> firmers = form.firmers.where((f){
      return ![f.firm, f.name, f.identifDocumentType, f.identifDocumentNumber].contains(null);
    }).toList();
    form.firmers = firmers;
  }
  
  Future initFirstFirmerFillingOut()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    _initOnFirstFirmerInformation();
    chosenForm.advanceInStep();
    await updateChosenFormInStorage(chosenForm);
  }

  Future initFirstFirmerFirm()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.advanceInStep();
    _addNewFirmer(InitFirstFirmerFirm());
    
    //await updateChosenFormInStorage(chosenForm);
  }

  Future updateFirmers()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    await _updateFirmersInForm(chosenForm);
    _advanceInStepIfIsInFirstFirmerFirm(chosenForm);
    await updateChosenFormInStorage(chosenForm);
    chosenFormB.add(UpdateFirmerPersonalInformation(firmer: chosenForm.firmers.last.clone()));
    print(chosenFormB.state.firmers.last);
    print(chosenForm.firmers.last);
    _addNewFirmer(InitFirmsFillingOut());
  }

  Future _updateFirmersInForm(Formulario form)async{
    form.firmers.add( chosenFormB.state.firmers.last.clone() );
    print(chosenFormB.state.firmers.last);
    print(form.firmers.last);
    final File currentFirmFile = await PainterToImageConverter.createFileFromFirmPainter(firmPaintB.state.firmPainter, form.firmers.length-1);
    form.firmers.last.firm = currentFirmFile;
  }

  void _advanceInStepIfIsInFirstFirmerFirm(Formulario form){
    if(form.formStep == FormStep.OnFirstFirmerFirm)
      form.advanceInStep();
  }

  void _addNewFirmer(ChosenFormEvent cfEvent){
    chosenFormB.add(cfEvent);
    firmPaintB.add(ResetFirmPaint());
  }

  Future endAllFormProcess()async{
    print(formsB.state.chosenForm);
    chosenFormB.add(InitFirmsFinishing());
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.formStep = FormStep.Finished;
    //await updateFirmers();
    await _updateFirmersInForm(chosenForm);
    await updateChosenFormInStorage(chosenForm);
    chosenFormB.add(ResetChosenForm());
    indexB.add(ResetAllOfIndex());  
  }

  Future updateCommentedImages()async{
    commImgsB.add(InitImagesCommenting());
    final List<UnSentCommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    _addCommentedImagesToBlocIfExistsInStorage(commentedImages);
  }

  void _addCommentedImagesToBlocIfExistsInStorage(List<UnSentCommentedImage> commentedImages)async{
    if(commentedImages.length > 0){
      _addCommentedImagesToBloc(commentedImages);
    } 
  }

  void _addCommentedImagesToBloc(List<UnSentCommentedImage> commentedImages)async{
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
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    await updateChosenProject(chosenProject);
    await updateVisits();
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    await updateChosenVisit(chosenVisit);
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