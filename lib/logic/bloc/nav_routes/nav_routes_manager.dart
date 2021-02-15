import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/storage_managers/navigation_route/navigation_route_storage_manager.dart';

class NavRoutesManager{
  NavigationRoute _currentRoute;
  
  Future loadRoute()async{
    final List<NavigationRoute> navRoutes = await NavigationRoutesStorageManager.getNavigationRoutes();
    if(navRoutes.length > 0)
      _currentRoute = navRoutes[navRoutes.length - 1];
  }

  Future replaceAllRoutesForNew(NavigationRoute initialRoute)async{
    await NavigationRoutesStorageManager.resetRoutes();
    await NavigationRoutesStorageManager.setNavigationRoute(initialRoute);
    _currentRoute = initialRoute;
  }

  Future setRoute(NavigationRoute newRoute)async{
    await NavigationRoutesStorageManager.setNavigationRoute(newRoute);
  }

  Future setRouteAfterPopping(NavigationRoute newRoute, int nPoppings)async{
    await NavigationRoutesStorageManager.removeNRoutes(nPoppings);
    await NavigationRoutesStorageManager.setNavigationRoute(newRoute);
  }

  NavigationRoute get currentRoute => _currentRoute;
}

final NavRoutesManager navRoutesManager = NavRoutesManager();