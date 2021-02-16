import 'package:flutter/material.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_manager/data_source_manager.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/ui/gap_app.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  doInitialConfig();
  return runApp(GapApp());
}

@protected
void doInitialConfig(){
  _initStorageManager();
  _setOnConnectionChange();
  _loadInitialRoute();
}

void _initStorageManager()async{
  DataSourceManager.blocs = BlocProvidersCreator.blocsAsMap;
  DataSourceManager.changeDataSourceFromConnectionState(await NetConnectionDetector.netConnectionState);
}

void _setOnConnectionChange(){
  NetConnectionDetector.onConnectionChange = (NetConnectionState netConnState){
    DataSourceManager.changeDataSourceFromConnectionState(netConnState);
  };
}

void _loadInitialRoute(){
  navRoutesManager.loadRoute();
}