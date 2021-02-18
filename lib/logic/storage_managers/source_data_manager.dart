import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/services_manager/forms_services_manager.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/services_manager/visits_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';

class SourceDataManager{
  static final SourceDataToBlocManager srcDataToBlocWithConnectionInitializer = _SourceDataWithConnectionInitializerManager();
  static final SourceDataToBlocManager srcDataToBlocWithConnectionUpdater = _SourceDataWithConnectionUpdaterManager();
  static final SourceDataToBlocManager srcDataToBlocWithoutConnection = SourceDataWithoutConnectionManager();

  // _SourceDataWithConnectionInitializerManager
  // _SourceDataWithConnectionUpdaterManager

  static Future<void> restartAppData(NetConnectionState netConnectionState)async{
    final SourceDadaFunctionTypeWithConnectionStateEnum srcDataFunctionTypeWithConnectionStateEnum = _chooseEnumByParams(SourceDataFunctionType.Init, netConnectionState);
    await _executeFunctionByParams(srcDataFunctionTypeWithConnectionStateEnum);
  }

  static Future<void> updateBlocData(NavigationRoute route)async{
    final NetConnectionState netConnectionState = await NetConnectionDetector.netConnectionState;
    final SourceDadaFunctionTypeWithConnectionStateEnum srcDataFunctionTypeWithConnectionStateEnum = _chooseEnumByParams(SourceDataFunctionType.SingleUpdate, netConnectionState);
    await _executeFunctionByParams(srcDataFunctionTypeWithConnectionStateEnum, route);
  }

  static SourceDadaFunctionTypeWithConnectionStateEnum _chooseEnumByParams(SourceDataFunctionType sdft, NetConnectionState netConnectionState){
    final SrcDataFunctionWithConnState srcDataFunctionWithConnState = SrcDataFunctionWithConnState(
      sdft,
      netConnectionState
    );
    return SourceDadaFunctionTypeWithConnectionStateEnum.fromValue(srcDataFunctionWithConnState);
  }

  static Future<void> _executeFunctionByParams(SourceDadaFunctionTypeWithConnectionStateEnum srcDataFunctionWithConnStateEnum, [NavigationRoute route])async{
    switch(srcDataFunctionWithConnStateEnum){
      case SourceDadaFunctionTypeWithConnectionStateEnum.ConnectedInit:
        _addDataToBlocsByNavRoutes(srcDataToBlocWithConnectionInitializer);
        break;
      case SourceDadaFunctionTypeWithConnectionStateEnum.ConnectedUpdate:
        srcDataToBlocWithConnectionUpdater.addDataToBlocByNavRoute(route);
        break;
      case SourceDadaFunctionTypeWithConnectionStateEnum.DisConnectedInit:
        _addDataToBlocsByNavRoutes(srcDataToBlocWithoutConnection);
        break;
      case SourceDadaFunctionTypeWithConnectionStateEnum.DisConnectedUpdate:
        srcDataToBlocWithoutConnection.addDataToBlocByNavRoute(route);
        break;
    }
  }

  static Future<void> _addDataToBlocsByNavRoutes(SourceDataToBlocManager sdbManager)async{
    final List<NavigationRoute> routes = await routesManager.routesTree;
    sdbManager.addDataToBlocsByNavRoutes(routes);
  }
}

abstract class SourceDataToBlocManager{

  final Map<BlocName, Bloc> blocsAsMap = BlocProvidersCreator.blocsAsMap;
  @protected
  Map<BlocName, Bloc> blocs;  
  List<NavigationRoute> navRoutes;
  Map<NavigationRoute, dynamic> dataAddedToBlocsByExistingNavs;

  Future<void> addDataToBlocsByNavRoutes(List<NavigationRoute> routes)async{
    dataAddedToBlocsByExistingNavs = {};
    await addStorageDataToUserBloc(blocsAsMap[BlocName.UserBloc]);
    for(NavigationRoute route in routes){
      await addDataToBlocByNavRoute(route);
    }
  }

  Future<void> addDataToBlocByNavRoute(NavigationRoute route)async{
    switch(route){
      case NavigationRoute.Login:   
        break;        
      case NavigationRoute.Projects:
        await addStorageDataToProjects(null);
        break;
      case NavigationRoute.ProjectDetail:
        await addStorageDataToChosenProject(null);
        break;
      case NavigationRoute.Visits:
        await addStorageDataToVisits(null);
        break;
      case NavigationRoute.VisitDetail:
        await addStorageDataToChosenVisit(null);
        break;
      case NavigationRoute.Formularios:
        await addStorageDataToFormulariosBloc(null);
        break;
      case NavigationRoute.FormularioDetailForms:
        await addStorageDataToChosenFormBloc(null);
        break;
      case NavigationRoute.FormularioDetailFirmers:
        break;
      case NavigationRoute.AdjuntarFotosVisita:
        await _addStorageDataToCommentedImagesBloc(null);
        break;        
    }
  }

  Future<void> addStorageDataToUserBloc(UserBloc bloc)async{
    final String authToken = await UserStorageManager.getAuthToken();
    final SetAuthToken satEvent = SetAuthToken(authToken: authToken);
    final UserBloc userBloc = blocsAsMap[BlocName.UserBloc];
    userBloc.add(satEvent);
  }

  @protected
  Future<void> addStorageDataToProjectsBlocIfExistsPagesInStorage(ProjectsBloc bloc)async{
    if(navRoutes.contains(NavigationRoute.Projects))
      await addStorageDataToProjects(bloc);
    if(navRoutes.contains(NavigationRoute.Visits))
      await addStorageDataToChosenProject(bloc);
  }

  @protected
  Future<void> addStorageDataToProjects(ProjectsBloc bloc)async{}

  Future<void> addStorageDataToChosenProject(ProjectsBloc bloc)async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    final ChooseProject cpEvent = ChooseProject(chosenOne: chosenOne);
    pBloc.add(cpEvent);
    dataAddedToBlocsByExistingNavs[NavigationRoute.ProjectDetail] = chosenOne;
  }

  @protected
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{}

  Future<void> addStorageDataToChosenVisit(VisitsBloc bloc)async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    final ChooseVisit cvEvent = ChooseVisit(chosenOne: chosenOne);
    vBloc.add(cvEvent);
    dataAddedToBlocsByExistingNavs[NavigationRoute.VisitDetail] = chosenOne;
  }

  @protected
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{}

  Future<void> addStorageDataToChosenFormBloc(ChosenFormBloc bloc)async{
    final ChosenFormBloc cfBloc = blocsAsMap[BlocName.ChosenForm];
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    final InitFormFillingOut iffoEvent= InitFormFillingOut(formulario: chosenOne);
    cfBloc.add(iffoEvent);
  }

  Future<void> _addStorageDataToCommentedImagesBloc(CommentedImagesBloc bloc)async{
    final CommentedImagesBloc ciBloc = blocsAsMap[BlocName.CommentedImages];
    final List<CommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
    final SetCommentedImages sciEvent = SetCommentedImages(commentedImages: commentedImages);
    ciBloc.add(sciEvent);
  }

  @protected
  Future<void> addStorageDataToIndexBloc(IndexBloc bloc)async{
    final IndexBloc indexBloc = blocsAsMap[BlocName.Index];
    final IndexState indexConfig = await IndexStorageManager.getIndex();
    final int nPages = indexConfig.nPages;
    final ChangeNPages cnpEvent = ChangeNPages(nPages: nPages);
    indexBloc.add(cnpEvent);
    final int newIndexPage = indexConfig.currentIndexPage;
    final ChangeIndexPage ciEvent = ChangeIndexPage(newIndexPage: newIndexPage);
    indexBloc.add(ciEvent);
  }
}

class SourceDataWithConnectionChildChooser{
  SourceDataWithConnectionManager getSourceDataManagerFromFunctionType(SourceDataFunctionType functionType){
    return SourceDataWithConnectionManager();
  }
}

class SourceDataWithConnectionManager extends SourceDataToBlocManager{
  @override
  Future<void> addStorageDataToProjects([ProjectsBloc bloc])async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    await ProjectsServicesManager.loadProjects(pBloc);
  }
}

class _SourceDataWithConnectionInitializerManager extends SourceDataWithConnectionManager{
  @override
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final List<Visit> visits = await VisitsStorageManager.getVisits();
    final SetVisits svEvent = SetVisits(visits: visits);
    vBloc.add(svEvent);
  }

  @override
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final List<Formulario> forms = await FormulariosStorageManager.getForms();
    final SetForms sfEvent = SetForms(forms: forms);
    fBloc.add(sfEvent);
  }
}

class _SourceDataWithConnectionUpdaterManager extends SourceDataWithConnectionManager{
  @override
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    await VisitsServicesManager.loadVisits(vBloc);
  }

  @override
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    await FormsServicesManager.loadForms(fBloc);
  }
}



class SourceDataWithoutConnectionManager extends SourceDataToBlocManager{
  @override
  Future<void> addStorageDataToProjects([ProjectsBloc bloc])async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final List<Project> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetProjects spEvent = SetProjects(projects: projectsWithPreloadedVisits);
    pBloc.add(spEvent);
  }

  @override
  Future<void> addStorageDataToVisits(VisitsBloc bloc)async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final Project chosenProject = dataAddedToBlocsByExistingNavs[NavigationRoute.ProjectDetail];
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(chosenProject.id);
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    vBloc.add(svEvent);
  }

  @override
  Future<void> addStorageDataToFormulariosBloc(FormulariosBloc bloc)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final Visit chosenVisit = dataAddedToBlocsByExistingNavs[NavigationRoute.VisitDetail];
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    fBloc.add(sfEvent);
  }
}