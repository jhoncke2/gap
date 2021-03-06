import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/helpers/painter_to_image_converter.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

abstract class DataDistributor{

  static final Map<BlocName, Bloc> blocsAsMap = BlocProvidersCreator.blocsAsMap;
  final Map<BlocName, ChangeNotifier> singletonesAsMap = BlocProvidersCreator.singletonesAsMap;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs = {};

  final ProjectsBloc projectsB =  blocsAsMap[BlocName.Projects];
  final VisitsBloc visitsB = blocsAsMap[BlocName.Visits];
  final FormulariosBloc formsB = blocsAsMap[BlocName.Formularios];
  final ChosenFormBloc chosenFormB = blocsAsMap[BlocName.ChosenForm];
  final FirmPaintBloc firmPaintB = blocsAsMap[BlocName.FirmPaint];


  Future<void> updateAccessToken()async{}

  Future<void> updateProjects()async{}

  Future<void> updateChosenProject(Project project)async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final ChooseProjectOld cpEvent = ChooseProjectOld(chosenOne: project);
    pBloc.add(cpEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = project;
  }

  Future<void> updateVisits()async{}
  
  Future<void> updateChosenVisit(Visit visit)async{}

  @protected
  Future addChosenVisitToBloc(Visit visit)async{
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: visit);
    blocsAsMap[BlocName.Visits].add(cvEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  Future<void> updateFormularios()async{}
  
  Future<void> updateChosenForm(Formulario form)async{
    final ChooseForm chooseFormEvent = ChooseForm(chosenOne: form);
    blocsAsMap[BlocName.Formularios].add(chooseFormEvent);
    await ChosenFormStorageManager.setChosenForm(form);
    await _chooseChosenFormStep(form);
  }

  Future _chooseChosenFormStep(Formulario form)async{
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
    }
  }

  void _initOnForm(Formulario form){
    chosenFormB.add(InitFormFillingOut(formulario: form, onEndEvent: _onEndInitFormFillingOut));
  }

  void _onEndInitFormFillingOut(int formFieldsPages){
    final IndexBloc indexBloc = blocsAsMap[BlocName.Index];
    indexBloc.add(ChangeNPages(nPages: formFieldsPages));
  }

  void _initOnFirstFirmerInformation(){
    chosenFormB.add(InitFirstFirmerFillingOut());
  }

  void _initOnFirstFirmerFirm(form){
    chosenFormB.add(InitFirstFirmerFirm());
  }

  void _onSecondaryFirms(Formulario form){
    chosenFormB.add(InitFirmsFillingOut());
  }

  Future endFormFillingOut()async{
    final Visit chosenVisit = visitsB.state.chosenVisit;
    final Formulario chosenForm = formsB.state.chosenForm;
    chosenForm.advanceInStep();
    _chooseChosenFormStep(chosenForm);
    await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, chosenVisit.id);
    //await _updateChosenFormInStorage();
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
    await updateFirmers();
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

  Future resetForms()async{}

  Future resetChosenForm()async{}

  Future resetCommentedImages()async{}
}


class UploadedBlocsData{
  static final Map<NavigationRoute, dynamic> dataContainer = {};
}