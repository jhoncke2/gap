import 'package:flutter/cupertino.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/preloaded_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/logic/central_managers/data_distributor/data_distributor_error_handler_manager.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/central_config/bloc_providers_creator.dart';
import 'package:gap/old_architecture/native_connectors/permissions.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;

class DataInitializer{
  static final ProjectsRepository projectsRepository = sl();
  static final VisitsRepository visitsRepository = sl();
  static final FormulariosRepository formulariosRepository = sl();
  static final PreloadedRepository preloadedRepository = sl();

  static final CustomNavigator customNavigator = sl();
  static final NavigationLocalDataSource navLocalDataSource = sl();

  //static final RoutesManager _routesManager = RoutesManager();
  bool _continueInitialization;

  Future init(BuildContext context, NetConnectionState netConnState)async{
    _continueInitialization = true;
    dataDisrtibutorErrorHandlingManager.netConnectionState = netConnState;
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.DO_FIRST_APP_INITIALIZATION);
    if(!dataDisrtibutorErrorHandlingManager.happendError){
      final PermissionStatus storagePermissionStatus = await NativeServicesPermissions.storageServiceStatus;
      await _doFunctionByStoragePermissionStatus(storagePermissionStatus, CustomNavigatorOld.navigatorKey.currentContext, netConnState);
    }else{
      await UserStorageManager.setFirstTimeRunned();
      _navigateToLogin(CustomNavigatorOld.navigatorKey.currentContext, netConnState);
    }
  }

  Future _doFunctionByStoragePermissionStatus(PermissionStatus permissionStatus, BuildContext context, NetConnectionState netConnState)async{
    if([PermissionStatus.undetermined, PermissionStatus.denied, PermissionStatus.restricted, PermissionStatus.limited, PermissionStatus.permanentlyDenied].contains(permissionStatus))
      await _repeatStoragePermissionValidation(permissionStatus, context, netConnState);
    else
      await _doInitialization(context, netConnState);
  }

  Future _repeatStoragePermissionValidation(PermissionStatus permissionStatus, BuildContext context, NetConnectionState netConnState)async{
    await dialogs.showErrDialog(context, 'Activa el permiso de almacenamiento para esta aplicación en configuración del dispositivo');
    await NativeServicesPermissions.openSettings();
    await _doFunctionByStoragePermissionStatus(permissionStatus, context, netConnState);
  }

  Future _navigateToLogin(BuildContext context, NetConnectionState netConnState)async{
    _defineLogginButtonAvaibleless(netConnState);
    await PagesNavigationManager.navToLogin();
  }

  void _defineLogginButtonAvaibleless(NetConnectionState netConnState)async{
    final bool loginButtonAvaibleless = (netConnState == NetConnectionState.Connected)? true : false;
    BlocProvidersCreator.userBloc.add(ChangeLoginButtopnAvaibleless(isAvaible: loginButtonAvaibleless));
  }

  Future _doInitialization(BuildContext context, NetConnectionState netConnState)async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.DO_INITIAL_CONFIG);
    if(dataDisrtibutorErrorHandlingManager.happendError){
      await _replaceAllNavRoutesByHavingError();
    }
    else
      await _continueInitializationAfterDoneInitialConfig(context, netConnState);
  }

  Future _continueInitializationAfterDoneInitialConfig(BuildContext context, NetConnectionState netConnState)async{
    await _sendPreloadedData();
    await _doAllNavigationByEvaluatingInitialConditions(context, netConnState);
  }

  Future<void> _sendPreloadedData()async{
    final eitherSentLoadedData = await preloadedRepository.sendPreloadedData();
    await eitherSentLoadedData.fold((l)async{
      await dialogs.showTemporalDialog('Ocurrió un error con el envío de los datos precargados');
    }, (seEnviaron)async{
      if(seEnviaron)
        await dialogs.showTemporalDialog('Se han enviado los formularios precargados');
    });
  }

  Future _doAllNavigationByEvaluatingInitialConditions(BuildContext context, NetConnectionState netConnState)async{
    if(await _currentNavRouteIsLogin()){
      await _navigateToLogin(context, netConnState);
    }else{
      await _doAllNavigationTree(context);
    }
  }

  Future<bool> _currentNavRouteIsLogin()async{
    final NavigationRoute currentNavRoute = (await navLocalDataSource.getNavRoutes()).last;
    return (currentNavRoute == NavigationRoute.Login);
  }

  Future _doAllNavigationTree(BuildContext context)async{
    final List<NavigationRoute> navRoutes = await navLocalDataSource.getNavRoutes();
    for(NavigationRoute nr in navRoutes){
      await _doUpdatingIfContinueInitialization(nr, context);
    }
    if(_continueInitialization){
      await customNavigator.navigateReplacingTo(navRoutes.last);
    }
    else{
      await _replaceAllNavRoutesByHavingError();
    }
  }

  Future _replaceAllNavRoutesByHavingError()async{
    await navLocalDataSource.removeNavRoutes();
    await navLocalDataSource.setNavRoute(dataDisrtibutorErrorHandlingManager.navigationTodoByError??NavigationRoute.Login);
    await customNavigator.navigateReplacingTo((await navLocalDataSource.getNavRoutes()).last);
  }

  Future _doUpdatingIfContinueInitialization(NavigationRoute nr, BuildContext context)async{
    if(_continueInitialization)
        await _doUpdating(nr, context);
    _evaluateifThereWasAnyErr();
  }

  Future _doUpdating(NavigationRoute navRoute, BuildContext context)async{
    switch(navRoute){
      case NavigationRoute.Projects:
        await _doProjectsUpdating();
        break;
      case NavigationRoute.ProjectDetail:
        await _doProjectDetailUpdating();
        break;
      case NavigationRoute.Visits:
        await _doVisitsUpdating();
        break;
      case NavigationRoute.VisitDetail:
        await _doVisitDetailUpdating();
        break;
      case NavigationRoute.Formularios:
        await _doFormsUpdating();
        break;    
      case NavigationRoute.FormularioDetail:
        await _doFormDetailUpdating();
        break;
      case NavigationRoute.AdjuntarFotosVisita:
        await _doAdjuntarFotosUpdating();
        break;
      case NavigationRoute.Firmers:
        await _doFirmersUpdating();
        break;
    }
  }

  Future _doProjectsUpdating()async{ 
   await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_PROJECTS);
  }

  Future _doProjectDetailUpdating()async{
    final eitherChosenProject = await projectsRepository.getChosenProject();
    await eitherChosenProject.fold((l)async{
      _continueInitialization = false;
    }, (chosenProject)async{
      final ProjectOld chosenProjectOld = ProjectOld(id: chosenProject.id, nombre: chosenProject.nombre, visits: []);
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_PROJECT, chosenProjectOld);
    });
    
  }

  Future _doVisitsUpdating()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_VISITS);
  }

  Future _doVisitDetailUpdating()async{
    final eitherChosenVisit = await visitsRepository.getChosenVisit();
    await eitherChosenVisit.fold((l)async{
      _continueInitialization = false;
    }, (chosenVisit)async{
      final VisitOld chosenVisitOld = VisitOld.fromNewVisit(chosenVisit);
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_VISIT, chosenVisitOld);
    });    
  }

  Future _doFormsUpdating()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FORMULARIOS);
  }

  Future _doFormDetailUpdating()async{
    final eitherChosenFormulario = await formulariosRepository.getChosenFormulario();
    await eitherChosenFormulario.fold((l)async{
      _continueInitialization = false;
    }, (chosenFormulario)async{
      FormularioOld chosenFormularioOld = FormularioOld.fromFormularioNew(chosenFormulario);
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_FORM, chosenFormularioOld);
    });
  }

  Future _doAdjuntarFotosUpdating()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_COMMENTED_IMAGES);
  }

  Future _doFirmersUpdating()async{
  }

  void _evaluateifThereWasAnyErr(){
    _continueInitialization = ! dataDisrtibutorErrorHandlingManager.happendError;
  }
}

DataInitializer dataInitializer = DataInitializer();