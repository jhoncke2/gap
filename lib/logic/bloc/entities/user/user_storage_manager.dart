import 'package:flutter/material.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class UserStorageManager{
  @protected
  static final String authTokenKey = 'auth_token';

  static Future<void> setAuthToken(String authToken)async{
    await StorageConnectorSingleton.storageConnector.setStringResource(authTokenKey, authToken);
  }

  static Future<String> getAuthToken()async{
    return await StorageConnectorSingleton.storageConnector.getStringResource(authTokenKey);
  }

  static Future<void> deleteAuthToken()async{
    await StorageConnectorSingleton.storageConnector.removeResource(authTokenKey);
  }
}