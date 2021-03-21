import 'package:flutter/material.dart';
import 'package:gap/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class UserStorageManager{
  @protected
  static final String _authTokenKey = 'auth_token';
  @protected
  static final String _userInformationKey = 'user_information';

  static Future<void> setAccessToken(String authToken)async{
    await StorageConnectorSingleton.storageConnector.setStringResource(_authTokenKey, authToken);
  }

  static Future<String> getAccessToken()async{
    final String authToken = await StorageConnectorSingleton.storageConnector.getStringResource(_authTokenKey);
    //TODO: Implementar lanzamiento de errores desde el storage connector.
    //_throwErrIfUnfound(authToken);
    return authToken;
  }

  static void _throwErrIfUnfound(String authToken){
    if([null, ''].contains(authToken))
      throw UnfoundStorageElementErr(elementType: StorageElementType.AUTH_TOKEN);
  }

  static Future<void> removeAuthToken()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_authTokenKey);
  }

  static Future setUserInformation(String email, String password)async{
    final Map<String, dynamic> userInformation = {'email':email, 'password':password};
    await StorageConnectorSingleton.storageConnector.setMapResource(_userInformationKey, userInformation);
  }

  static Future getUserInformation()async{
    final Map<String, dynamic> userInfo = await StorageConnectorSingleton.storageConnector.getMapResource(_userInformationKey);
    return userInfo;
  }
}