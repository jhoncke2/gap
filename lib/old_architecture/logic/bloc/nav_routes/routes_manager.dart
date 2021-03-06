import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/logic/storage_managers/navigation_route/navigation_routes_storage_manager.dart';

class RoutesManager{
  NavigationRoute _currentRoute;
  
  Future loadRoute()async{
    final List<NavigationRoute> navRoutes = await NavigationRoutesStorageManager.getNavigationRoutes();
    if(navRoutes.length > 0)
      _currentRoute = navRoutes.last;
  }

  Future updateLastRoute()async{
    final List<NavigationRoute> routesTree = await NavigationRoutesStorageManager.getNavigationRoutes();
    await CustomNavigatorOld.navigateReplacingTo(routesTree.last);
  }

  Future replaceAllRoutesForNew(NavigationRoute initialRoute)async{
    await NavigationRoutesStorageManager.resetRoutes();
    await NavigationRoutesStorageManager.setNavigationRoute(initialRoute);
    _currentRoute = initialRoute;
    await CustomNavigatorOld.navigateReplacingTo(initialRoute);
  }

  Future setRoute(NavigationRoute newRoute)async{
    await NavigationRoutesStorageManager.setNavigationRoute(newRoute);
    await CustomNavigatorOld.navigateReplacingTo(newRoute);
    await loadRoute();
  }
/*
  Future setRouteAfterPopping(NavigationRoute newRoute, int nPoppings)async{
    await NavigationRoutesStorageManager.removeNRoutes(nPoppings);
    await NavigationRoutesStorageManager.setNavigationRoute(newRoute);
    //await _doNPoppingsToNavigator(nPoppings);
    await CustomNavigator.navigateReplacingTo(newRoute);
    await loadRoute();
  }
*/


  Future pop()async{
    await NavigationRoutesStorageManager.removeNRoutes(1);
    await loadRoute();
    await CustomNavigatorOld.navigateReplacingTo(_currentRoute);
  }

  Future popNTimes(int n)async{
    await NavigationRoutesStorageManager.removeNRoutes(n);
    await loadRoute();
    await CustomNavigatorOld.navigateReplacingTo(_currentRoute);
  }

  NavigationRoute get currentRoute => _currentRoute;
  Future<List<NavigationRoute>> get routesTree async => await NavigationRoutesStorageManager.getNavigationRoutes();
  
  Future<bool> get hasPreviousRoute async{
    final List<NavigationRoute> navRoutesTree = await routesTree;
    return navRoutesTree.length > 1;
  }
  
  Future<NavigationRoute> get lastNavRoute async{
    final List<NavigationRoute> navRoutesTree = await routesTree;
    return navRoutesTree[navRoutesTree.length - 2];
  }
  
}

final RoutesManager routesManager = RoutesManager();