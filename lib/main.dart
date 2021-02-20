import 'package:flutter/material.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import 'package:gap/ui/gap_app.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/ui/pages/init_page.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await doInitialConfig();
  return runApp(GapApp());
}

@protected
Future<void> doInitialConfig()async{
  //await _initStorageManager();
  _setOnConnectionChange();
  _loadInitialRoute();
  _testAddingAuthorization();
  _listenInitPage();
  //await _testRemovePartOfStorage();
}

Future<void> _initStorageManager()async{
  await DataDistributor.updateAppData(await NetConnectionDetector.netConnectionState);
}

void _setOnConnectionChange(){
  NetConnectionDetector.onConnectionChange = (NetConnectionState netConnState){
    DataDistributor.updateAppData(netConnState);
  };
}

void _loadInitialRoute(){
  routesManager.loadRoute();
}

void _testAddingAuthorization(){
  UserStorageManager.setAuthToken('new_auth_token');
}

Future<void> _testRemovePartOfStorage()async{
  UserStorageManager.removeAuthToken();
  StorageConnector sc = StorageConnector();
  await sc.removeResource('projects_with_preloaded_visits');
  await sc.removeResource('preloaded_visits');
  await sc.removeResource('preloaded_forms');
}

void _listenInitPage(){
  InitPage.contextStream.listen(
    (BuildContext context)async{
      print('A new context is here: ');
      print(context);
      print('******');
      await DataDistributor.updateAppData(await NetConnectionDetector.netConnectionState);
    }
  );
}