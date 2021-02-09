import 'package:flutter/material.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class UserStorageManager{
  final String authTokenKey = 'auth_token';
  final StorageConnector storageConnector;
  UserStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ; 

  UserStorageManager.forTesting({
    @required this.storageConnector
  });

  Future<void> setAuthToken(String authToken)async{
    await storageConnector.setStringResource(authTokenKey, authToken);
  }

  Future<String> getAuthToken()async{
    return await storageConnector.getStringResource(authTokenKey);
  }

  Future<void> deleteAuthToken()async{
    await storageConnector.removeResource(authTokenKey);
  }
}