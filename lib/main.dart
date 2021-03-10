import 'package:flutter/material.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/ui/gap_app.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  //await doInitialConfig();
  return runApp(GapApp());
}

@protected
Future<void> doInitialConfig()async{
  //await _setOnConnectionChange();
  //_listenInitPage();
  //_testAddAuthorizationToken();
  await _testRemovePartOfStorage();
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
  await sc.setStringResource('new_auth_token', 'fake_auth_token');
}