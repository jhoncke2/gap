import 'package:flutter/material.dart';
import 'package:gap/old_architecture/native_connectors/permissions.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';
import 'package:gap/old_architecture/native_connectors/net_connection_detector.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/logic/central_managers/data_initializer.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/ui/gap_app.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;
import 'clean_architecture_structure/injection_container.dart' as ic;

GapApp app;
void main()async{
  await doInitialConfig();
  ic.init();
  return runApp(app);
}

@protected
Future<void> doInitialConfig()async{
  WidgetsFlutterBinding.ensureInitialized();
  //await _testRemovePartOfStorage();
  //await _testAddInitialUserInformation();
  app = GapApp();
  WidgetsBinding.instance.addObserver(app.state);
  app.state.didChangeDependenciesMethod = _onStartingApp;
  app.state.didChangeAppLifecycleStateMethod = _onResumeApp;
}

Future _onStartingApp()async{
  if(await NativeServicesPermissions.storageIsGranted || true)
    await _initApp(null);
  else
    await _requestStorageActivation();
}

void _onResumeApp(AppLifecycleState state)async{
  print(CustomNavigatorOld.navigatorKey.currentState.widget.initialRoute);
  //CustomNavigator.navigatorKey.currentState.popUntil((route) => route.isCurrent);
  /*
  if(state == AppLifecycleState.resumed){
    if(await NativeServicesPermissions.storageIsGranted || true){
      final List<NavigationRoute> routesTree = await routesManager.routesTree;
      if(routesTree.last != NavigationRoute.AdjuntarFotosVisita)
        await _initDataInitialization(null);
    }
    //else
      //await _requestStorageActivation();
    */
}

Future _initApp(BuildContext context)async{
  await _initDataInitialization(context);
  await _setOnConnectionChange(context);
}

Future _initDataInitialization(BuildContext context)async{
  final NetConnectionState netConnectionState = await NetConnectionDetector.netConnectionState;
  await dataInitializer.init(context, netConnectionState);
} 

Future _setOnConnectionChange(BuildContext context)async{
  await NetConnectionDetector.initCurrentNavConnectionState();
  NetConnectionDetector.onConnectionChange = (NetConnectionState connState){
    _onConnectionChanged(connState, context);
  };
}

Future _onConnectionChanged(NetConnectionState newConnState, BuildContext context)async{
  await dataInitializer.init(context, newConnState);
}

Future _requestStorageActivation()async{
  await dialogs.showErrDialog(CustomNavigatorOld.navigatorKey.currentContext, 'Por favor activa el servicio de almacenamiento para esta app en configuración del dispositivo');
  await NativeServicesPermissions.openSettings();
}

Future<void> _testRemovePartOfStorage()async{
  await UserStorageManager.removeAuthToken();
  StorageConnectorOld sc = StorageConnectorOld();
  await sc.removeResource('new_auth_token');
  await sc.removeResource('user');
  await sc.removeResource('projects_with_preloaded_visits');
  await sc.removeResource('preloaded_visits');
  await sc.removeResource('preloaded_forms');
  await sc.setStringResource('new_auth_token', 'fake_auth_token');
  await sc.removeResource('user_information');
  await sc.removeResource('first_time_runned');
}

Future _testAddInitialUserInformation()async{
  StorageConnectorOld sc = StorageConnectorOld();
  final Map<String, dynamic> emailInfo = {
    'email': 'oskrjag@gmail.com',
    'password': '12345678'
  };
  await sc.setMapResource('user_information', emailInfo);
}