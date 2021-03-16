import 'package:gap/logic/central_manager/data_distributor/data_distributor_error_handler_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor_manager.dart';
import 'package:gap/logic/central_manager/preloaded_storage_to_services.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/native_connectors/permissions.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

class DataInitializer{
  static final RoutesManager _routesManager = RoutesManager();
  final DataDistributorManager _dataDistributorManager = DataDistributorManager();
  bool _continueInitialization;

  Future init(BuildContext context, NetConnectionState netConnState)async{
    _continueInitialization = true;
    final PermissionStatus storagePermissionStatus = await NativeServicesPermissions.storageServiceStatus;
    await _doFunctionByStoragePermissionStatus(storagePermissionStatus, context, netConnState);
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
    dataDisributorErrorHandlingManager.netConnectionState = netConnState;
    await _sendPreloadedDataIfThereIsConnection(netConnState);
    final String accessToken = await UserStorageManager.getAccessToken();
    await _doInitializationByAccessToken(accessToken, context, netConnState);
  }

  Future _doInitializationByAccessToken(String accessToken, BuildContext context, NetConnectionState netConnState)async{
    if(accessToken == null)
      await _navigateToLogin(context, netConnState);
    else
      await _doInitialization(accessToken, context, netConnState);
  }

  Future _doInitialization(String accessToken, BuildContext context, NetConnectionState netConnState)async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
    if(!dataDisributorErrorHandlingManager.happendError)
      await _continueInitializationAfterUpdateToken(context, netConnState);
  }

  Future _continueInitializationAfterUpdateToken(BuildContext context, NetConnectionState netConnState)async{
    await _routesManager.loadRoute();
    await _doAllNavigationByEvaluatingInitialConditions(context, netConnState);
  }

  Future _sendPreloadedDataIfThereIsConnection(NetConnectionState netConnState)async{
    if(netConnState == NetConnectionState.Connected)
      await PreloadedStorageToServices.sendPreloadedStorageDataToServices();
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

  Future _navigateToLogin(BuildContext context, NetConnectionState netConnState)async{
    _defineLogginButtonAvaibleless(netConnState);
    await PagesNavigationManager.navToLogin();
  }

  void _defineLogginButtonAvaibleless(NetConnectionState netConnState)async{
    final bool loginButtonAvaibleless = (netConnState == NetConnectionState.Connected)? true : false;
  BlocProvidersCreator.userBloc.add(ChangeLoginButtopnAvaibleless(isAvaible: loginButtonAvaibleless));
  }

  Future _doAllNavigationTree(BuildContext context)async{
    final List<NavigationRoute> navRoutes = await _routesManager.routesTree;
    for(NavigationRoute nr in navRoutes){
      await _doNavigationIfContinueInitialization(nr, context);
    }
    if(_continueInitialization)
      await _routesManager.setRouteAfterPopping(navRoutes[navRoutes.length - 1], 1);
    
  }

  Future _doNavigationIfContinueInitialization(NavigationRoute nr, BuildContext context)async{
    _evaluateifThereWasAnyErr();
    if(_continueInitialization)
        await _doNavigation(nr, context);
  }

  Future _doNavigation(NavigationRoute navRoute, BuildContext context)async{
    switch(navRoute){
      case NavigationRoute.Projects:
        await _doNavigationToProjects();
        break;
      case NavigationRoute.ProjectDetail:
        await _doNavigationToProjectDetail();
        break;
      case NavigationRoute.Visits:
        await _doNavigationToVisits();
        break;
      case NavigationRoute.VisitDetail:
        await _doNavigationToVisitDetail();
        break;
      case NavigationRoute.Formularios:
        await _doNavigationToForms();
        break;    
      case NavigationRoute.FormularioDetailForms:
        await _doNavigationToFormDetail();
        break;
      case NavigationRoute.AdjuntarFotosVisita:
        await _doNavigationToAdjuntarFotos();
        break;
    }
  }

  Future _doNavigationToProjects()async{ 
    //await _dataDistributorManager.dataDistributor.updateProjects();
   // await _dataDistributorManager.executeFunction(DataDistrFunctionName.UPDATE_PROJECTS);
   await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_PROJECTS);
  }

  Future _doNavigationToProjectDetail()async{
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    //await _dataDistributorManager.dataDistributor.updateChosenProject(chosenOne);
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_PROJECT, chosenOne);
  }

  Future _doNavigationToVisits()async{
    await _dataDistributorManager.dataDistributor.updateVisits();
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_VISITS);
  }

  Future _doNavigationToVisitDetail()async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    //await _dataDistributorManager.dataDistributor.updateChosenVisit(chosenOne);
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_VISIT, chosenOne);
  }

  Future _doNavigationToForms()async{
    //await _dataDistributorManager.dataDistributor.updateFormularios();
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FORMULARIOS);
  }

  Future _doNavigationToFormDetail()async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    //await _dataDistributorManager.dataDistributor.updateChosenForm(chosenOne);
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_FORM, chosenOne);
  }


  Future _doNavigationToAdjuntarFotos()async{
    //await _dataDistributorManager.dataDistributor.updateCommentedImages();
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_COMMENTED_IMAGES);
  }

  void _evaluateifThereWasAnyErr(){
    _continueInitialization = ! dataDisributorErrorHandlingManager.happendError;
  }
}

DataInitializer dataInitializer = DataInitializer();