import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
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
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/native_connectors/gps.dart';
import 'package:geolocator/geolocator.dart';

abstract class DataDistributor{

  static final Map<BlocName, Bloc> blocsAsMap = BlocProvidersCreator.blocsAsMap;
  final Map<BlocName, ChangeNotifier> singletonesAsMap = BlocProvidersCreator.singletonesAsMap;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs = {};

  final ProjectsBloc projectsB =  blocsAsMap[BlocName.Projects];
  final VisitsBloc visitsB = blocsAsMap[BlocName.Visits];
  final FormulariosBloc formsB = blocsAsMap[BlocName.Formularios];
  final ChosenFormBloc chosenFormB = blocsAsMap[BlocName.ChosenForm];
  final FirmPaintBloc firmPaintB = blocsAsMap[BlocName.FirmPaint];
  final IndexBloc indexB = blocsAsMap[BlocName.Index];
  final CommentedImagesBloc commImgsB = blocsAsMap[BlocName.CommentedImages];

  Future<void> updateAccessToken(String accessToken)async{}

  Future testingGeneralUpdateProjects()async{
    await updateProjects();

  }

  Future<void> updateProjects()async{}

  Future<void> updateChosenProject(Project project)async{
    final List<Project> projects = projectsB.state.projects;
    final List<Project> equalsUpdatedProjects = projects.where((element) => element.id == project.id).toList();
    final Project realProject = equalsUpdatedProjects.length > 0? equalsUpdatedProjects[0] : project;
    final ChooseProject cpEvent = ChooseProject(chosenOne: realProject);
    projectsB.add(cpEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = project;
    await ProjectsStorageManager.setChosenProject(realProject);
  }

  Future<void> updateVisits()async{}
  
  Future<void> updateChosenVisit(Visit visit)async{
    final List<Visit> visits = visitsB.state.visits;
    final List<Visit> updatedEqualsVisits = visits.where((element) => element.id == visit.id).toList();
    final Visit realVisit = updatedEqualsVisits.length > 0? updatedEqualsVisits[0] : visit;
    await addChosenVisitToBloc(realVisit);
    await VisitsStorageManager.setChosenVisit(realVisit);
  }

  @protected
  Future addChosenVisitToBloc(Visit visit)async{
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: visit);
    blocsAsMap[BlocName.Visits].add(cvEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  Future<void> updateFormularios()async{}
  
  Future<void> updateChosenForm(Formulario form)async{
    final List<Formulario> forms = formsB.state.forms;
    final List<Formulario> updatedEqualsForms = forms.where((element) => element.id == form.id).toList();
    final Formulario realForm = (updatedEqualsForms.length > 0)? updatedEqualsForms[0] : form;
    await _addInitialPosition(realForm);
    formsB.add(ChooseForm(chosenOne: realForm));
    await ChosenFormStorageManager.setChosenForm(realForm);
    await _chooseBlocMethodByChosenFormStep(realForm);
    
  }

  Future _addInitialPosition(Formulario form)async{
    final Position currentPosition = await GPS.gpsPosition;
    form.initialPosition = currentPosition;
  }

  Future _chooseBlocMethodByChosenFormStep(Formulario form)async{
    switch(form.formStep){ 
      case FormStep.WithoutForm:
        break;
      case FormStep.OnForm:
        _initOnForm(form);
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
        break;
    }
  }

  void _initOnForm(Formulario form){
    chosenFormB.add(InitFormFillingOut(formulario: form, onEndEvent: _onEndInitFormFillingOut));

  }

  void _onEndInitFormFillingOut(int formFieldsPages){
    final IndexBloc indexBloc = blocsAsMap[BlocName.Index];
    indexBloc.add(ChangeNPages(nPages: formFieldsPages, onEnd: _updateFormFieldsPage));
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

  Future updateFormFieldsPage()async{
    final int indexPage = indexB.state.currentIndexPage;
    //chosenFormB.add(UpdateFormField(pageOfFormField: indexPage, onEndFunction: _onUpdateFormFields));
    _updateFormFieldsPage(indexPage);
  }

  void _changeIndexActivation(bool isActive)async{
    indexB.add(ChangeSePuedeAvanzar(sePuede: isActive));
  }

  Future endFormFillingOut()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    await _addFinalPosition(chosenForm);
    chosenForm.advanceInStep();
    _initOnFirstFirmerInformation();
    await _updateChosenFormInStorage();
  }

  Future _addFinalPosition(Formulario form)async{
    final Position currentPosition = await GPS.gpsPosition;
    form.finalPosition = currentPosition;
  }

  Future _updateChosenFormInStorage()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    await ChosenFormStorageManager.setChosenForm(chosenForm);
    await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, visitsB.state.chosenVisit.id);
  }
  
  Future initFirstFirmerFillingOut()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.advanceInStep();
    chosenFormB.add(InitFirmsFillingOut());
    await _updateChosenFormInStorage();
  }

  Future initFirstFirmerFirm()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.advanceInStep();
    _addNewFirmer(InitFirstFirmerFirm());
    await _updateChosenFormInStorage();
  }

  Future updateFirmers()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.firmers = chosenFormB.state.firmers;
    final File currentFirmFile = await PainterToImageConverter.createFileFromFirmPainter(firmPaintB.state.firmPainter, chosenForm.firmers.length-1);
    chosenForm.firmers.last.firm = currentFirmFile;
    //_updateFormStepInFirmers(chosenForm);
    _advanceInStepIfIsInFirstFirmerFirm(chosenForm);
    await ChosenFormStorageManager.setChosenForm(chosenForm);
    await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, visitsB.state.chosenVisit.id);
    _addNewFirmer(InitFirmsFillingOut());
  }

  void _addNewFirmer(ChosenFormEvent cfEvent){
    chosenFormB.add(cfEvent);
    firmPaintB.add(ResetFirmPaint());
  }

  void _advanceInStepIfIsInFirstFirmerFirm(Formulario form){
    if(form.formStep == FormStep.OnFirstFirmerFirm)
      form.advanceInStep();
  }

  Future endAllFormProcess()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.formStep = FormStep.Finished;
    await updateFirmers();
    chosenFormB.add(ResetChosenForm());
    indexB.add(ResetAllOfIndex());
    
  }

  Future updateCommentedImages()async{
    final List<CommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    _addCommentedImagesToBlocIfExistsInStorage(commentedImages);
  }

  void _addCommentedImagesToBlocIfExistsInStorage(List<CommentedImage> commentedImages)async{
    if(commentedImages.length > 0){
      _addCommentedImagesToBloc(commentedImages);
    } 
  }

  void _addCommentedImagesToBloc(List<CommentedImage> commentedImages)async{
    final CommentedImagesBloc ciBloc = blocsAsMap[BlocName.CommentedImages];
    final SetCommentedImages sciEvent = SetCommentedImages(commentedImages: commentedImages);
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
    final AddImages addImagesEvent = AddImages(images: imgsBloc.state.currentPhotosToSet, onEnd: (){ _changeNPagesToIndex(commImagesBloc, indexBloc); });
    commImagesBloc.add(addImagesEvent);
  }

  void _changeNPagesToIndex(CommentedImagesBloc commImagesBloc, IndexBloc indexBloc){
    final CommentedImagesState commImgsState = commImagesBloc.state;
    final int newIndexNPages = commImgsState.nPaginasDeCommImages;
    final ChangeNPages changesNPagesEvent = ChangeNPages(nPages: newIndexNPages);
    indexBloc.add(changesNPagesEvent);
  }

  void _resetFotosPorAgregar(ImagesBloc imgsBloc){ 
    final ResetImages resetAllEvent = ResetImages();
    imgsBloc.add(resetAllEvent);
  }

  Future endCommentedImagesProcess()async{
    commImgsB.add(ResetCommentedImages());
    indexB.add(ResetAllOfIndex());
    await updateProjects();
    await updateVisits();
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
    await ProjectsStorageManager.removeChosenProject();
    await updateProjects();
  }

  Future resetVisits()async{
    await VisitsStorageManager.removeVisits();
  }

  Future resetChosenVisit()async{
    await CommentedImagesStorageManager.removeCommentedImages();
    final CommentedImagesBloc cmBloc = blocsAsMap[BlocName.CommentedImages];
    cmBloc.add(ResetCommentedImages());
    await VisitsStorageManager.removeChosenVisit();
  }

  Future resetForms()async{
    await updateProjects();
    await updateVisits();
  }

  Future resetChosenForm()async{}

  Future resetCommentedImages()async{}
}


class UploadedBlocsData{
  static final Map<NavigationRoute, dynamic> dataContainer = {};
}


/*
  EnumValues<DataDistrFunctionName, Function> _dataDistributorFunctionsValues;
  Function _lastExecutedFunction;

  DataDistributor(){
    _initializeDataDistributorFunctionsValues();
  }

  final List functionsWithValue = [
    DataDistrFunctionName.UPDATE_ACCESS_TOKEN, 
    DataDistrFunctionName.UPDATE_CHOSEN_PROJECT,
    DataDistrFunctionName.UPDATE_CHOSEN_VISIT, 
    DataDistrFunctionName.UPDATE_CHOSEN_FORM
  ];

  _initializeDataDistributorFunctionsValues(){
    _dataDistributorFunctionsValues =  EnumValues<DataDistrFunctionName, Function>({
      DataDistrFunctionName.UPDATE_ACCESS_TOKEN: updateAccessToken,
      DataDistrFunctionName.UPDATE_PROJECT: updateAccessToken,
      DataDistrFunctionName.UPDATE_CHOSEN_PROJECT: updateAccessToken,
      DataDistrFunctionName.UPDATE_VISITS: updateAccessToken,
      DataDistrFunctionName.UPDATE_CHOSEN_VISIT: updateAccessToken,
      DataDistrFunctionName.UPDATE_FORMULARIOS: updateAccessToken,
      DataDistrFunctionName.UPDATE_CHOSEN_FORM: updateAccessToken,
      DataDistrFunctionName.END_FORM_FILLING_OUT: updateAccessToken,
      DataDistrFunctionName.INIT_FIRST_FIRMER_FILLING_OUT: updateAccessToken,
      DataDistrFunctionName.INIT_FIRST_FIRMER_FIRM: updateAccessToken,
      DataDistrFunctionName.UPDATE_FIRMERS: updateAccessToken,
      DataDistrFunctionName.END_ALL_FORM_PROCESS: updateAccessToken,
      DataDistrFunctionName.UPDATE_COMMENTED_IMAGES: updateAccessToken,
      DataDistrFunctionName.END_COMMENTED_IMAGES_PROCESS: updateAccessToken,
      DataDistrFunctionName.ADD_STORAGE_DATA_TO_INDEX_BLOC: updateAccessToken,
      DataDistrFunctionName.RESET_CHOSEN_PROJECT: updateAccessToken,
      DataDistrFunctionName.RESET_VISITS: updateAccessToken,
      DataDistrFunctionName.RESET_CHOSEN_VISIT: updateAccessToken,
      DataDistrFunctionName.RESET_FORMS: updateAccessToken,
      DataDistrFunctionName.RESET_CHOSEN_FORM: updateAccessToken,
      DataDistrFunctionName.RESET_COMMENTED_IMAGES: updateAccessToken,
    });
  }

  Future executeFunction(DataDistrFunctionName functionName, [dynamic value])async{
    try{
      _tryExecuteFunctionByName(functionName);
    }on ServiceStatusErr catch(err){
      if(err.extraInformation == 'refresh_token')
        await PagesNavigationManager.navToLogin();
      else{
        final String accessToken = await UserStorageManager.getAccessToken();
        await executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
      }
    }on UnfoundStorageElementErr catch(err){
      if(err.elementType == StorageElementType.AUTH_TOKEN)
        await PagesNavigationManager.navToLogin();
      else
        await PagesNavigationManager.navToProjects();
    }catch(err){
      await PagesNavigationManager.navToProjects();
    }
  }

  Future _tryExecuteFunctionByName(DataDistrFunctionName functionName, [dynamic value])async{
    _lastExecutedFunction = _dataDistributorFunctionsValues.map[functionName];
    if(functionsWithValue.contains(functionName))
      await _lastExecutedFunction(value);
    else
      await _lastExecutedFunction();
  }

*/