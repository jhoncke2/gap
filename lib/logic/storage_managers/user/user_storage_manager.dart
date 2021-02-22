import 'package:flutter/material.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class UserStorageManager{
  @protected
  static final String _authTokenKey = 'auth_token';

  static Future<void> setAuthToken(String authToken)async{
    await StorageConnectorSingleton.storageConnector.setStringResource(_authTokenKey, authToken);
  }

  static Future<String> getAuthToken()async{
    return await StorageConnectorSingleton.storageConnector.getStringResource(_authTokenKey);
  }

  static Future<void> removeAuthToken()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_authTokenKey);
  }
}