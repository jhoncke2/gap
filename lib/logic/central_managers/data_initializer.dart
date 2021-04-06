import 'package:gap/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/logic/central_managers/data_distributor/data_distributor_error_handler_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/native_connectors/permissions.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

class DataInitializer{
  static final RoutesManager _routesManager = RoutesManager();
  bool _continueInitialization;

  Future init(BuildContext context, NetConnectionState netConnState)async{
    _continueInitialization = true;
    dataDisrtibutorErrorHandlingManager.netConnectionState = netConnState;
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.DO_FIRST_APP_INITIALIZATION);
    if(!dataDisrtibutorErrorHandlingManager.happendError){
      final PermissionStatus storagePermissionStatus = await NativeServicesPermissions.storageServiceStatus;
      await _doFunctionByStoragePermissionStatus(storagePermissionStatus, CustomNavigator.navigatorKey.currentContext, netConnState);
    }else{
      await UserStorageManager.setFirstTimeRunned();
      _navigateToLogin(CustomNavigator.navigatorKey.currentContext, netConnState);
    }
  }

  Future _doFunctionByStoragePermissionStatus(PermissionStatus permissionStatus, BuildContext context, NetConnectionState netConnState)async{
    if([PermissionStatus.undetermined, PermissionStatus.denied, PermissionStatus.restricted, PermissionStatus.limited, PermissionStatus.permanentlyDenied].contains(permissionStatus))
      await _repeatStoragePermissionValidation(permissionStatus, context, netConnState);
    else
      await _init(context, netConnState);
  }

  Future _repeatStoragePermissionValidation(PermissionStatus permissionStatus, BuildContext context, NetConnectionState netConnState)async{
    await dialogs.showErrDialog(context, 'Activa el permiso de almacenamiento para esta aplicación en configuración del dispositivo');
    await NativeServicesPermissions.openSettings();
    await _doFunctionByStoragePermissionStatus(permissionStatus, context, netConnState);
  }

  Future _init(BuildContext context, NetConnectionState netConnState)async{
    final String accessToken = await UserStorageManager.getAccessToken();
    await _doInitializationByAccessToken(accessToken, context, netConnState);
  }

  Future _doInitializationByAccessToken(String accessToken, BuildContext context, NetConnectionState netConnState)async{
    if(accessToken == null)
      await _navigateToLogin(context, netConnState);
    else
      await _doInitialization(context, netConnState);
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
    if(dataDisrtibutorErrorHandlingManager.happendError)
      await _routesManager.replaceAllRoutesForNew(dataDisrtibutorErrorHandlingManager.navigationTodoByError??NavigationRoute.Login);
    else
      await _continueInitializationAfterDoneInitialConfig(context, netConnState);
  }

  Future _continueInitializationAfterDoneInitialConfig(BuildContext context, NetConnectionState netConnState)async{
    await _routesManager.loadRoute();
    await _doAllNavigationByEvaluatingInitialConditions(context, netConnState);
  }

  Future _doAllNavigationByEvaluatingInitialConditions(BuildContext context, NetConnectionState netConnState)async{
    if(await _currentNavRouteIsLogin()){
      await _navigateToLogin(context, netConnState);
    }else{
      await _doAllNavigationTree(context);
    }
  }

  Future<bool> _currentNavRouteIsLogin()async{
    final NavigationRoute currentNavRoute = _routesManager.currentRoute;
    return (currentNavRoute == NavigationRoute.Login);
  }

  Future _doAllNavigationTree(BuildContext context)async{
    final List<NavigationRoute> navRoutes = await _routesManager.routesTree;
    for(NavigationRoute nr in navRoutes){
      await _doUpdatingIfContinueInitialization(nr, context);
    }
    if(_continueInitialization)
      await _routesManager.updateLastRoute();
    else
      await _routesManager.replaceAllRoutesForNew(dataDisrtibutorErrorHandlingManager.navigationTodoByError??NavigationRoute.Login);
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
      case NavigationRoute.FormularioDetailForms:
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
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_PROJECT, chosenOne);
  }

  Future _doVisitsUpdating()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_VISITS);
  }

  Future _doVisitDetailUpdating()async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_VISIT, chosenOne);
  }

  Future _doFormsUpdating()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FORMULARIOS);
  }

  Future _doFormDetailUpdating()async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_FORM, chosenOne);
  }


  Future _doAdjuntarFotosUpdating()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_COMMENTED_IMAGES);
  }

  Future _doFirmersUpdating()async{
    // Deberían haberse actualizado los firmers en el _doFormDetailUpdating (el chosen form contenia las firmas)
    //await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.)
  }

  void _evaluateifThereWasAnyErr(){
    _continueInitialization = ! dataDisrtibutorErrorHandlingManager.happendError;
  }
}

DataInitializer dataInitializer = DataInitializer();