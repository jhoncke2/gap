import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/storage_managers/navigation_route/navigation_route_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import './navigation_route_storage_manager_descriptions.dart' as descriptions;

final List<NavigationRoute> _fakeRoutes = [
  NavigationRoute.Init, //Nunca se guardará en el storage. Se eliminará de la cola inmediatamente se use.
  NavigationRoute.Login,
  NavigationRoute.Projects,
  NavigationRoute.ProjectDetail,
  NavigationRoute.Visits,
  NavigationRoute.VisitDetail,
  NavigationRoute.Formularios,
  NavigationRoute.FormularioDetailForms,
  NavigationRoute.FormularioDetailFirmers,
  NavigationRoute.AdjuntarFotosVisita
];

void main(){
  _initStorageConnector();
  group(descriptions.navigationRouteGroupDescription, (){
    _testSetNavigationRoutes();
    _testGetNavigationRoutes();
    _testRemoveNavigationRoutes();
    _testResetNavRoutes();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetNavigationRoutes(){
  test(descriptions.testSeNavigationRouteDescription, ()async{
    await _tryTestSetNavigationRoutes();
  });
}

Future<void> _tryTestSetNavigationRoutes()async{
  await _setNavigationRoutes();

}

Future<void> _setNavigationRoutes()async{
  for(int i = 0; i < _fakeRoutes.length; i++){
    await NavigationRoutesStorageManager.setNavigationRoute(_fakeRoutes[i]);
  }
}

void _testGetNavigationRoutes(){
  test(descriptions.testSeNavigationRouteDescription, ()async{
    await _tryTestGetNavigationRoutes();
  });
}

Future<void> _tryTestGetNavigationRoutes()async{
  final List<NavigationRoute> navRoutes = await NavigationRoutesStorageManager.getNavigationRoutes();
  expect(navRoutes.length, _fakeRoutes.length, reason: 'El length de los nav routes del storage debe ser igual al length de los fake nav routes');
  for(int i = 0; i < navRoutes.length; i++){
    expect(navRoutes[i], _fakeRoutes[i], reason: 'El actual nav route del storage debe ser igual al actual fake nav route definido en el test');
  }
}

void _testRemoveNavigationRoutes(){
  test(descriptions.testSeNavigationRouteDescription, ()async{
    await _tryTestRemoveNavigationRoutes();
  });
}

Future<void> _tryTestRemoveNavigationRoutes()async{
  for(int removed = 0, toRemove = 0; removed < _fakeRoutes.length;){
    toRemove++;
    removed += toRemove;
    await _verifyRemoveNRoutes(toRemove, removed);
  }
}

Future<void> _verifyRemoveNRoutes(int toRemove, int removed)async{
  await NavigationRoutesStorageManager.removeNRoutes(toRemove);
  final List<NavigationRoute> navRoutes = await NavigationRoutesStorageManager.getNavigationRoutes();
  expect(navRoutes.length, _fakeRoutes.length - removed, reason: 'Se borró $toRemove elemento(s), el tamaño debe ser menor en $toRemove a los fake nav routes');
  _verifyIsInitialSublistOfFakeRoutes(navRoutes);
}

void _verifyIsInitialSublistOfFakeRoutes(List<NavigationRoute> sublist){
  for(int i = 0; i < sublist.length; i++)
    expect(sublist[i], _fakeRoutes[i], reason: 'El elemento actual de los navRoutes del storage debe ser igual al de los fake routes');
}

void _testResetNavRoutes(){
  test(descriptions.testSeNavigationRouteDescription, ()async{
    await _tryTestResetNavRoutes();
  });
}

Future<void> _tryTestResetNavRoutes()async{
  await _setNavigationRoutes();
  await NavigationRoutesStorageManager.resetRoutes();
  final List<NavigationRoute> routes = await NavigationRoutesStorageManager.getNavigationRoutes();
  expect(routes.length, 0, reason: 'Las rutas deben estar vacías debido a que se acaban de resetear');
}

