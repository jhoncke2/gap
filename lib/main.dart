import 'package:flutter/material.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_managers/data_source_manager.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/ui/gap_app.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  _initStorageManager();
  _setOnConnectionChange();
  return runApp(GapApp());
}

void _initStorageManager(){
  DataSourceManager.blocs = BlocProvidersCreator.blocsAsMap;
}

void _setOnConnectionChange(){
  NetConnectionDetector.onConnectionChange = (NetConnectionState netConnState){
    print('On connection change: $netConnState');
  };
}