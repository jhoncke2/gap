import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/errors/storage/unfound_storage_element_err.dart';
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

  Future init(BuildContext context, NetConnectionState netConnState)async{
    try{
      //_navigateToLogin(context, netConnState);
      _tryInit(context, netConnState);
    }on ServiceStatusErr catch(_){
      _navigateToLogin(context, netConnState);
    }on UnfoundStorageElementErr catch(err){
      if(err.elementType == StorageElementType.AUTH_TOKEN)
        _navigateToLogin(context, netConnState);
      else
        PagesNavigationManager.navToProjects();
    }catch(err){
      PagesNavigationManager.navToProjects();
    }
  }

  Future _tryInit(BuildContext context, NetConnectionState netConnState)async{
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
    final bool settingsAreOpened = await NativeServicesPermissions.openSettings();
    await _doFunctionByStoragePermissionStatus(permissionStatus, context, netConnState);
  }

  Future _init(BuildContext context, NetConnectionState netConnState)async{
    DataDistributorManager.netConnectionState = netConnState;
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
    await DataDistributorManager.dataDistributor.updateAccessToken(accessToken);
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
      await _doNavigation(nr, context);
    }
    await _routesManager.setRouteAfterPopping(navRoutes[navRoutes.length - 1], 1);
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

  static Future _doNavigationToProjects()async{ 
    await DataDistributorManager.dataDistributor.updateProjects();
  }

  static Future _doNavigationToProjectDetail()async{
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    await DataDistributorManager.dataDistributor.updateChosenProject(chosenOne);
  }

  static Future _doNavigationToVisits()async{
    await DataDistributorManager.dataDistributor.updateVisits();
  }

  static Future _doNavigationToVisitDetail()async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    await DataDistributorManager.dataDistributor.updateChosenVisit(chosenOne);
  }

  static Future _doNavigationToForms()async{
    await DataDistributorManager.dataDistributor.updateFormularios();
  }

  static Future _doNavigationToFormDetail()async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    await DataDistributorManager.dataDistributor.updateChosenForm(chosenOne);
  }


  static Future _doNavigationToAdjuntarFotos()async{
    await DataDistributorManager.dataDistributor.updateCommentedImages();
  }
}

DataInitializer dataInitializer = DataInitializer();