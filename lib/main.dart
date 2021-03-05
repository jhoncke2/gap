import 'package:flutter/material.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_manager/data_initializer.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/ui/gap_app.dart';
import 'package:gap/ui/pages/init_page.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  doInitialConfig();
  return runApp(GapApp());
}

@protected
Future<void> doInitialConfig()async{
  await _setOnConnectionChange();
  _listenInitPage();
  //_testAddAuthorizationToken();
  //await _testRemovePartOfStorage();
}

Future _setOnConnectionChange()async{
  await NetConnectionDetector.initCurrentNavConnectionState();
  NetConnectionDetector.onConnectionChange = _onConnectionChanged;
}

void _onConnectionChanged(NetConnectionState newConnState){
  DataInitializer.init(null, newConnState);
}


void _testAddAuthorizationToken(){
  UserStorageManager.setAccessToken('new_auth_token');
}

Future<void> _testRemovePartOfStorage()async{
  UserStorageManager.removeAuthToken();
  StorageConnector sc = StorageConnector();
  await sc.removeResource('new_auth_token');
  await sc.removeResource('projects_with_preloaded_visits');
  await sc.removeResource('preloaded_visits');
  await sc.removeResource('preloaded_forms');
}

void _listenInitPage(){
  InitPage.contextStream.listen(
    (BuildContext context)async{
      final NetConnectionState netConnectionState = await NetConnectionDetector.netConnectionState;
      await DataInitializer.init(context, netConnectionState);
    }
  );
}