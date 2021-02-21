import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/blocs_manager/pages_navigation_manager.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class DataInitializer{
  static final RoutesManager _routesManager = RoutesManager();

  static Future init(BuildContext context, NetConnectionState netConnState)async{
    //TODO: post preloaded data
    DataDistributorManager.netConnectionState = netConnState;
    await _routesManager.loadRoute();
    await _doAllNavigationByEvaluatingInitialConditions(context);
    
  }

  static Future _doAllNavigationByEvaluatingInitialConditions(BuildContext context)async{
    if(await _hasToInitAtLogin()){
      await _navigateToLogin(context);
    }else{
      await _doAllNavigationTree(context);
    }
  }

  static Future<bool> _hasToInitAtLogin( )async{
    return (await _authTokenDoesntExistInStorage() || await _currentNavRouteIsLogin());
  }

  static Future<bool> _authTokenDoesntExistInStorage()async{
    final String authToken = await UserStorageManager.getAuthToken();
    return (authToken == null);
  }

  static Future<bool> _currentNavRouteIsLogin()async{
    final NavigationRoute currentNavRoute = _routesManager.currentRoute;
    return (currentNavRoute == NavigationRoute.Login);
  }

  static Future _navigateToLogin(BuildContext context)async{
    await PagesNavigationManager.navToLogin();
    //await _routesManager.replaceAllRoutesForNew(NavigationRoute.Login);
    //Navigator.of(context).pushReplacementNamed(NavigationRoute.Login.value);
  }

  static Future _doAllNavigationTree(BuildContext context)async{
    final List<NavigationRoute> navRoutes = await _routesManager.routesTree;
    for(NavigationRoute nr in navRoutes){
      await _doNavigation(nr, context);
    }
    await _routesManager.setRouteAfterPopping(navRoutes[navRoutes.length - 1], 1);
  }

  static Future _doNavigation(NavigationRoute navRoute, BuildContext context)async{
    switch(navRoute){
      case NavigationRoute.Projects:
        await _doNavigationToProjects(context);
        break;
      case NavigationRoute.ProjectDetail:
        await _doNavigationToProjectDetail(context);
        break;
      case NavigationRoute.Visits:
        await _doNavigationToVisits(context);
        break;
      case NavigationRoute.VisitDetail:
        await _doNavigationToVisitDetail(context);
        break;
      case NavigationRoute.Formularios:
        await _doNavigationToForms(context);
        break;    
      case NavigationRoute.FormularioDetailForms:
        await _doNavigationToFormDetail(context);
        break;
      case NavigationRoute.AdjuntarFotosVisita:
        break;
    }
  }

  static Future _doNavigationToProjects(BuildContext context)async{ 
    await DataDistributorManager.dataDistributor.updateProjects();
  }

  static Future _doNavigationToProjectDetail(BuildContext context)async{
    final Project chosenOne = await ProjectsStorageManager.getChosenProject();
    await DataDistributorManager.dataDistributor.updateChosenProject(chosenOne);
    //await PagesNavigationManager.navToProjectDetail(chosenOne, context);
  }

  static Future _doNavigationToVisits(BuildContext context)async{
    //await PagesNavigationManager.navToVisits(context);
    await DataDistributorManager.dataDistributor.updateVisits();
  }

  static Future _doNavigationToVisitDetail(BuildContext context)async{
    final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
    await DataDistributorManager.dataDistributor.updateChosenVisit(chosenOne);
    //await PagesNavigationManager.navToVisitDetail(chosenOne, context);
  }

  static Future _doNavigationToForms(BuildContext context)async{
    await DataDistributorManager.dataDistributor.updateFormularios();
    //await PagesNavigationManager.navToForms(context);
  }

  static Future _doNavigationToFormDetail(BuildContext context)async{
    final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
    await DataDistributorManager.dataDistributor.updateChosenForm(chosenOne);
    //await PagesNavigationManager.navToFormDetail(chosenOne, context);
  }
}