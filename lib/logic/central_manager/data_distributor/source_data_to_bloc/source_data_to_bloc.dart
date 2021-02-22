
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

abstract class SourceDataToBloc{

  final Map<BlocName, Bloc> blocsAsMap = BlocProvidersCreator.blocsAsMap;
  @protected
  Map<BlocName, Bloc> blocs;  
  List<NavigationRoute> navRoutes;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs = {};

  SourceDataToBloc();

  Future<void> addDataToBlocsByNavRoutes(List<NavigationRoute> routes)async{
    await addStorageDataToUserBloc();
    if(!_authTokenExists())
      return;
    await _addDataToBlocs(routes);
  }

  Future<void> addStorageDataToUserBloc()async{
    final String authToken = await UserStorageManager.getAuthToken();
    final SetAuthToken satEvent = SetAuthToken(authToken: authToken);
    final UserBloc userBloc = blocsAsMap[BlocName.UserBloc];
    userBloc.add(satEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.Init] = authToken;
    
  }

  bool _authTokenExists(){
    final String authToken = UploadedBlocsData.dataContainer[NavigationRoute.Init];
    return authToken != null;
  }

  Future<void> _addDataToBlocs(List<NavigationRoute> routes)async{
    for(NavigationRoute route in routes){
      await addDataToBlocByNavRoute(route);
    }
  }

  Future<void> addDataToBlocByNavRoute(NavigationRoute route, [Entity entityToAdd])async{
    switch(route){
      case NavigationRoute.Login:   
        break;        
      case NavigationRoute.Projects:
        await updateProjects();
        break;
      case NavigationRoute.ProjectDetail:
        await updateChosenProject(entityToAdd);
        break;
      case NavigationRoute.Visits:
        await updateVisits();
        break;
      case NavigationRoute.VisitDetail:
        await updateChosenVisit(entityToAdd);
        break;
      case NavigationRoute.Formularios:
        await updateFormularios();
        break;
      case NavigationRoute.FormularioDetailForms:
        await updateChosenForm(entityToAdd);
        break;
      case NavigationRoute.FormularioDetailFirmers:
        break;
      case NavigationRoute.AdjuntarFotosVisita:
        await _addStorageDataToCommentedImagesBloc();
        break;        
    }
  }

  Future<void> updateProjects()async{}

  Future<void> updateChosenProject([Entity entityToAdd])async{
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    await addChosenProjectToBloc(chosenOne);
  }

  Future<void> addChosenProjectToBloc(Project project)async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final ChooseProject cpEvent = ChooseProject(chosenOne: project);
    pBloc.add(cpEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = project;
  }

  Future<void> updateVisits()async{}
  
  Future<void> updateChosenVisit([Entity entityToAdd])async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    await addChosenVisitToBloc(chosenOne);
  }
  
  Future<void> addChosenVisitToBloc(Visit visit)async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: visit);
    vBloc.add(cvEvent);
    dataAddedToBlocsByExistingNavs[NavigationRoute.VisitDetail] = visit;
    UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail] = visit;
  }

  Future<void> updateFormularios()async{}
  
  Future<void> updateChosenForm([Entity entityToAdd])async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    await addChosenFormToBlocs(chosenOne);
  }

  Future<void> addChosenFormToBlocs(Formulario form)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final ChooseForm chooseFormEvent = ChooseForm(chosenOne: form);
    fBloc.add(chooseFormEvent);
    final ChosenFormBloc cfBloc = blocsAsMap[BlocName.ChosenForm];
    final InitFormFillingOut iffoEvent= InitFormFillingOut(formulario: form);
    cfBloc.add(iffoEvent);
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

  Future<void> _addStorageDataToCommentedImagesBloc()async{
    final CommentedImagesBloc ciBloc = blocsAsMap[BlocName.CommentedImages];
    final List<CommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    final SetCommentedImages sciEvent = SetCommentedImages(commentedImages: commentedImages);
    ciBloc.add(sciEvent);
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