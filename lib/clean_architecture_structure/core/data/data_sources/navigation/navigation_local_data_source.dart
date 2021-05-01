import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

abstract class NavigationLocalDataSource{
  Future<void> setNavRoute(NavigationRoute navRoute);
  Future<List<NavigationRoute>> getNavRoutes();
  Future<void> removeNavRoutes();
  Future<void> removeLast();
}

class NavigationLocalDataSourceImpl implements NavigationLocalDataSource{
  static const ROUTES_STORAGE_KEY = 'routes';
  final StorageConnector storageConnector;

  NavigationLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<List<NavigationRoute>> getNavRoutes()async{
    final List<Map<String, dynamic>> jsonNavRoutes = await storageConnector.getList(ROUTES_STORAGE_KEY);
    final List<NavigationRoute> navRoutes = jsonNavRoutes.map((jnr) => NavigationRoute.fromJson(jnr)).toList();
    return navRoutes;
  }

  @override
  Future<void> setNavRoute(NavigationRoute navRoute)async{
    List<Map<String, dynamic>> jsonNavRoutes = await storageConnector.getList(ROUTES_STORAGE_KEY);
    //No funciona el jsonNavRoutes.add({'route':navRoute.value})
    jsonNavRoutes = [...jsonNavRoutes, {'route':navRoute.value}];
    await storageConnector.setList(jsonNavRoutes, ROUTES_STORAGE_KEY);
  }

  @override
  Future<void> removeNavRoutes()async{
    await storageConnector.remove(ROUTES_STORAGE_KEY);
  }

  @override
  Future<void> removeLast()async{
    List<Map<String, dynamic>> jsonNavRoutes = await storageConnector.getList(ROUTES_STORAGE_KEY);
    jsonNavRoutes.removeLast();
    await storageConnector.setList(jsonNavRoutes, ROUTES_STORAGE_KEY);
  }
}