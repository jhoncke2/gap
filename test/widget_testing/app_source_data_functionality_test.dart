import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/storage_managers/navigation_route/navigation_routes_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/ui/gap_app.dart';
import 'package:gap/main.dart' as appMain;
import 'package:gap/ui/utils/static_data/buttons_keys.dart';

void main(){
  WidgetsBinding wb = TestWidgetsFlutterBinding.ensureInitialized();
  _testAppInitialization();
}

void _testAppInitialization(){
  // ignore: missing_return
  testWidgets('The main app initialization', (WidgetTester tester)async{
    await _tryTestAppInitialization(tester);

  });
}

Future<void> _tryTestAppInitialization(WidgetTester tester)async{
  appMain.doInitialConfig();
  //await UserStorageManager.removeAuthToken();
  await tester.pumpWidget(GapApp());

  //await _expectStorageWithoutAuthTokenRoutes();
  
  final RoutesManager routesManager = RoutesManager();
  //_expectInitialRoutesManagerRoute(routesManager);
  //expect(routesManager.currentRoute, NavigationRoute.Login, reason: 'La ruta inicial sin authToken debe ser login');
  //await _expectLoginButtonTap(tester, routesManager);
}

Future<void> _expectStorageWithoutAuthTokenRoutes()async{
  final List<NavigationRoute> routes = await NavigationRoutesStorageManager.getNavigationRoutes();
  expect(routes, isNotNull, reason: 'Las rutas no deben ser null');
  expect(routes.length, 0, reason: 'El tamaño de las rutas debe ser 0');
}

void _expectInitialRoutesManagerRoute(RoutesManager routesManager){
  expect(routesManager.currentRoute, null, reason: 'La ruta debe ser null');
}

Future<void> _expectLoginButtonTap(WidgetTester tester, RoutesManager routesManager)async{
  final loginButton = find.byKey(ButtonsKeys.loginButtonKey);
  expect(loginButton, findsOneWidget, reason: 'Debería existir uno y solo un elemento con la key de loginKey');
  tester.tap(loginButton);
  expect(routesManager.currentRoute, isNotNull, reason: 'Se cambió de page. El route no debería ser null');
  expect(routesManager.currentRoute, NavigationRoute.Projects, reason: 'La ruta actual debería pertenecer a projects');
}