import 'package:flutter/material.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_manager/data_initializer_manager.dart';
import 'package:gap/logic/storage_managers/source_data_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/ui/gap_app.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await doInitialConfig();
  return runApp(GapApp());
}

@protected
Future<void> doInitialConfig()async{
  await _initStorageManager();
  _setOnConnectionChange();
  _loadInitialRoute();
  _testAddingAuthorization();
}

Future<void> _initStorageManager()async{
  await SourceDataManager.restartAppData(await NetConnectionDetector.netConnectionState);
  DataInitializerManager.blocs = BlocProvidersCreator.blocsAsMap;
  //DataInitializerManager.changeDataSourceFromConnectionState(await NetConnectionDetector.netConnectionState);
}

void _setOnConnectionChange(){
  
  NetConnectionDetector.onConnectionChange = (NetConnectionState netConnState){
    SourceDataManager.restartAppData(netConnState);
    //DataInitializerManager.changeDataSourceFromConnectionState(netConnState);
  };
}

void _loadInitialRoute(){
  routesManager.loadRoute();
}

void _testAddingAuthorization(){
  //UserStorageManager.setAuthToken('new_auth_token');
  UserStorageManager.removeAuthToken();
}