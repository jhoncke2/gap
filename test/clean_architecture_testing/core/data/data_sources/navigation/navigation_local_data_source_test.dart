import 'package:flutter/services.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockStorageConnector extends Mock implements StorageConnector{}

NavigationLocalDataSourceImpl dataSource;
MockStorageConnector storageConnector;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    dataSource = NavigationLocalDataSourceImpl(
      storageConnector: storageConnector
    );
  });

  group('getNavRoutes', (){
    List<NavigationRoute> tNavRoutes;
    List<Map<String, dynamic>> tJsonNavRoutes;
    setUp((){
      tNavRoutes = [NavigationRoute.Projects, NavigationRoute.ProjectDetail, NavigationRoute.Visits];
      tJsonNavRoutes = tNavRoutes.map((nr) => {'route':nr.value}).toList();
    });
    
    test('should call the tNavRoutesString from storageConnector and return the tNavRoutes', ()async{
      when(storageConnector.getList(any)).thenAnswer((_) async => tJsonNavRoutes);
      final List<NavigationRoute> navRoutes = await dataSource.getNavRoutes();
      verify(storageConnector.getList(NavigationLocalDataSourceImpl.ROUTES_STORAGE_KEY));
      expect(navRoutes, tNavRoutes);
    });

  });

  group('setNavRoute', (){
    List<NavigationRoute> tNavRoutes;
    List<Map<String, dynamic>> tJsonNavRoutes;
    NavigationRoute tNewNavRoute;
    List<Map<String, dynamic>> tJsonUpdatedNavRoutes;
    setUp((){
      tNavRoutes = [NavigationRoute.Projects, NavigationRoute.ProjectDetail, NavigationRoute.Visits];
      tNewNavRoute = NavigationRoute.VisitDetail;
      tJsonNavRoutes = tNavRoutes.map((nr) => {'route':nr.value}).toList();
      tJsonUpdatedNavRoutes = tNavRoutes.map((nr) => {'route':nr.value}).toList()..add({'route':tNewNavRoute.value});
    });

    test('should call the storageConnector.setList() with the tJsonUpdatedNavRoutes', ()async{
      when(storageConnector.getList(any)).thenAnswer((_) async => tJsonNavRoutes);
      await dataSource.setNavRoute(tNewNavRoute);
      verify(storageConnector.getList(NavigationLocalDataSourceImpl.ROUTES_STORAGE_KEY));
      verify(storageConnector.setList(tJsonUpdatedNavRoutes, NavigationLocalDataSourceImpl.ROUTES_STORAGE_KEY));
    });

  });

  group('resetNavRoute', (){
    test('should call the storageConnector.remove(Storage_Key)', ()async{
      await dataSource.removeNavRoutes();
      verify(storageConnector.remove(NavigationLocalDataSourceImpl.ROUTES_STORAGE_KEY));
    });
  });

  group('removeLast', (){
    List<NavigationRoute> tNavRoutes;
    List<Map<String, dynamic>> tJsonNavRoutes;
    List<Map<String, dynamic>> tJsonUpdatedNavRoutes;
    setUp((){
      tNavRoutes = [NavigationRoute.Projects, NavigationRoute.ProjectDetail, NavigationRoute.Visits];
      tJsonNavRoutes = tNavRoutes.map((nr) => {'route':nr.value}).toList();
      tJsonUpdatedNavRoutes = tNavRoutes.map((nr) => {'route':nr.value}).toList()..removeLast();
    });

    test('''should get the tNavRoutes, remove the last, and set the updatedNavRoutes 
    into the storageConnector''', ()async{
      when(storageConnector.getList(any)).thenAnswer((_) async => tJsonNavRoutes);
      await dataSource.removeLast();
      verify(storageConnector.getList(NavigationLocalDataSourceImpl.ROUTES_STORAGE_KEY));
      verify(storageConnector.setList(tJsonUpdatedNavRoutes, NavigationLocalDataSourceImpl.ROUTES_STORAGE_KEY));
    });
  });
}