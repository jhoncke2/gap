import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class NavigationRoutesStorageManager{
  static final String _navigationRoutesKey = 'navigation_routes_old';

  static Future<void> setNavigationRoute(NavigationRoute newRoute)async{
    final List<Map<String, dynamic>> routes = await _obtainNavigationRoutesFromStorage();
    routes.add({ 'route': newRoute.value, 'step':null});
    await _updateStorageWithNewRoutes(routes);
  }

  /*
  static Future replaceAllNavigationTree(List<NavigationRoute> navRoutes)async{
    final List<Map<String, dynamic>> jsonNavRoutes = navRoutes.map((r) => {'route':r.value, 'step':r.step}).toList();
    await _updateStorageWithNewRoutes(jsonNavRoutes);
  }
  */
  
  static Future<List<NavigationRoute>> getNavigationRoutes()async{
    final List<Map<String, dynamic>> routesAsJson = await _obtainNavigationRoutesFromStorage();
    final List<NavigationRoute> routes = routesAsJson.map<NavigationRoute>(
      (Map<String, dynamic> r) => NavigationRoute.fromJson(r)
    ).toList();
    return routes;
  }
  
  static Future<void> removeNRoutes(int n)async{
    final List<Map<String, dynamic>> routes = await _obtainNavigationRoutesFromStorage();
    for(int i = 0; i < n; i++){
      if(routes.isNotEmpty)
        routes.removeLast();
    } 
    await _updateStorageWithNewRoutes(routes);
  }

  
  static Future<void> resetRoutes()async{
    await _updateStorageWithNewRoutes([]);
  }

  static Future<List<Map<String, dynamic>>> _obtainNavigationRoutesFromStorage()async{
    final List<Map<String, dynamic>> routes = await StorageConnectorOldSingleton.storageConnector.getListResource(_navigationRoutesKey);
    return routes;
  }

  static Future<void> _updateStorageWithNewRoutes(List<Map<String, dynamic>> routes)async{
    await StorageConnectorOldSingleton.storageConnector.setListResource(_navigationRoutesKey, routes);
  }
  
}
