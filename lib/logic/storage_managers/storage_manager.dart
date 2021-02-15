import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/storage_managers/navigation_route/navigation_route_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/nav_routes_manager.dart';

abstract class StorageBlocsManager{
  @protected
  Map<BlocName, Bloc> blocs;
  List<NavigationRoute> navRoutes;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs;

  Future<void> addStorageDataToBlocs(Map<BlocName, Bloc> blocs)async{
    navRoutes = await NavigationRoutesStorageManager.getNavigationRoutes();
    dataAddedToBlocsByExistingNavs = {};
    this.blocs = blocs;
    blocs.forEach((blocName, bloc){
      _addStorageDataToBloc(blocName, bloc);
    });
  }

  void _addStorageDataToBloc(BlocName name, Bloc bloc){
    switch(name){
      case BlocName.UserBloc:
        // TODO: Handle this case.
        break;
      case BlocName.Projects:
        addStorageDataToProjectsBlocIfExistsPagesInStorage(bloc);
        break;
      case BlocName.Visits:
        addStorageDataToVisitsBlocIfExistsPagesInStorage(bloc);
        break;
      case BlocName.Formularios:
        addStorageDataToFormulariosBlocIfExistsPageInStorage(bloc);
        break;
      case BlocName.ChosenForm:
        addStorageDataToChosenFormBlocIfExistsPageInStorage(bloc);
        break;
      case BlocName.Images:
        break;
      case BlocName.CommentedImages:
        addStorageDataToCommentedImagesBlocIfExistsPageInStorage(bloc);
        break;
      case BlocName.FirmPaint:
        break;
      case BlocName.Index:
        //TODO: Arreglar problema con index null desde storage
        //addStorageDataToIndexBloc(bloc);
        break;
    }
  }

  @protected
  Future<void> addStorageDataToProjectsBlocIfExistsPagesInStorage(ProjectsBloc bloc)async{
    if(navRoutes.contains(NavigationRoute.Projects))
      await addStorageDataToProjects(bloc);
    if(navRoutes.contains(NavigationRoute.Visits))
      await _addStorageDataToChosenProject(bloc);
  }

  @protected
  Future<void> addStorageDataToProjects(ProjectsBloc bloc)async{}

  Future<void> _addStorageDataToChosenProject(ProjectsBloc bloc)async{
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    final ChooseProject cpEvent = ChooseProject(chosenOne: chosenOne);
    dataAddedToBlocsByExistingNavs[NavigationRoute.ProjectDetail] = chosenOne;
    bloc.add(cpEvent);
  }

  @protected
  Future<void> addStorageDataToVisitsBlocIfExistsPagesInStorage(VisitsBloc vBloc)async{
    if(navRoutes.contains(NavigationRoute.Visits))
      await addStorageDataToVisits(vBloc);
    if(navRoutes.contains(NavigationRoute.VisitDetail))
      await _addStorageDataToChosenVisit(vBloc);
  }

  @protected
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{}

  Future<void> _addStorageDataToChosenVisit(VisitsBloc bloc)async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: chosenOne);
    bloc.add(cvEvent);
    dataAddedToBlocsByExistingNavs[NavigationRoute.VisitDetail] = chosenOne;
  }

  @protected
  Future<void> addStorageDataToFormulariosBlocIfExistsPageInStorage(FormulariosBloc bloc)async{}

  @protected
  bool thereIsPageInStorage(NavigationRoute navRoute){
    return navRoutes.contains(navRoute);
  }

  @protected
  Future<void> addStorageDataToChosenFormBlocIfExistsPageInStorage(ChosenFormBloc bloc)async{
    if(thereIsPageInStorage(NavigationRoute.FormularioDetailForms))
      _addStorageDataToChosenFormBloc(bloc);
    
  }

  Future<void> _addStorageDataToChosenFormBloc(ChosenFormBloc bloc)async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    final InitFormFillingOut iffoEvent= InitFormFillingOut(formulario: chosenOne);
    bloc.add(iffoEvent);
  }

  @protected
  Future<void> addStorageDataToCommentedImagesBlocIfExistsPageInStorage(CommentedImagesBloc bloc)async{
    if(thereIsPageInStorage(NavigationRoute.AdjuntarFotosVisita))
      _addStorageDataToCommentedImagesBloc(bloc);
  }

  Future<void> _addStorageDataToCommentedImagesBloc(CommentedImagesBloc bloc)async{
    final List<CommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    final SetCommentedImages sciEvent = SetCommentedImages(commentedImages: commentedImages);
    bloc.add(sciEvent);
  }

  @protected
  Future<void> addStorageDataToIndexBlocIfExistsPageInStorage(IndexBloc bloc)async{
    if(thereIsPageWithIndexInStorage())
      _addStorageDataToIndexBloc(bloc);
  }

  @protected
  Future<void> _addStorageDataToIndexBloc(IndexBloc bloc)async{
    final IndexStorageManager ism = IndexStorageManager();
    final IndexState indexConfig = await ism.getIndexConfig();
    final int nPages = indexConfig.nPages;
    final ChangeNPages cnpEvent = ChangeNPages(nPages: nPages);
    bloc.add(cnpEvent);
    final int newIndexPage = indexConfig.currentIndexPage;
    final ChangeIndexPage ciEvent = ChangeIndexPage(newIndexPage: newIndexPage);
    bloc.add(ciEvent);
  }

  bool thereIsPageWithIndexInStorage(){
    return thereIsPageInStorage(NavigationRoute.FormularioDetailForms) || thereIsPageInStorage(NavigationRoute.AdjuntarFotosVisita);
  }
}



class StorageRecentActivityBlocsManager extends StorageBlocsManager{

  @override
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{
    final List<Visit> visits = await VisitsStorageManager.getVisits();
    final SetVisits svEvent = SetVisits(visits: visits);
    bloc.add(svEvent);
  }

  @override
  Future<void> addStorageDataToFormulariosBlocIfExistsPageInStorage(FormulariosBloc bloc)async{
    if(thereIsPageInStorage(NavigationRoute.Formularios))
      await _addStorageDataToFormulariosBloc(bloc);
  }

  Future<void> _addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{
    final List<Formulario> forms = await FormulariosStorageManager.getForms();
    final SetForms sfEvent = SetForms(forms: forms);
    bloc.add(sfEvent);
  }
}



class StoragePreloadedDataBlocsManager extends StorageBlocsManager{

  @override
  Future<void> addStorageDataToProjects(ProjectsBloc bloc)async{
    final List<Project> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetProjects spEvent = SetProjects(projects: projectsWithPreloadedVisits);
    bloc.add(spEvent);
  }

  @override
  Future<void> addStorageDataToVisits(VisitsBloc vBloc)async{
    final Project chosenProject = dataAddedToBlocsByExistingNavs[NavigationRoute.ProjectDetail];
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getPreloadedVisitsByProjectId(chosenProject.id);
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    vBloc.add(svEvent);
  }

  @override
  Future<void> addStorageDataToFormulariosBlocIfExistsPageInStorage(FormulariosBloc bloc)async{
    if(thereIsPageInStorage(NavigationRoute.Formularios))
      await _addStorageDataToFormulariosBloc(bloc);
  }

  Future<void> _addStorageDataToFormulariosBloc(FormulariosBloc fBloc)async{
    final Visit chosenVisit = dataAddedToBlocsByExistingNavs[NavigationRoute.VisitDetail];
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    fBloc.add(sfEvent);
  }
}