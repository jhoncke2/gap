import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'user_storage_manager_descriptions.dart' as descriptions;

final String fakeAuthToken = 'fake_auth_token';
final Map<String, dynamic> fakeUserInformation = {
  'email':'email1@gmail.com',
  'password':'password123'
};

/*
void main(){
  _initStorageConnector();
  group(descriptions.authTokenGroupDescription, (){
    _testSetAuthToken();
    _testGetAuthToken();
    _testRemoveAuthToken();
  });

  group(descriptions.userInformationGroupDescription, (){   
    _testSetUserInformation();
    _testGetUserInformation();
  });
}
*/

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  //StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetAuthToken(){
  test(descriptions.testSetAuthTokenDescription, ()async{
    try{
      await _tryTestSetAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetAuthToken()async{
  await UserStorageManager.setAccessToken(fakeAuthToken);
}

void _testGetAuthToken(){
  test(descriptions.testGetAuthTokenDescription, ()async{
    try{
      await _tryTestGetAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetAuthToken()async{
  final String authToken = await UserStorageManager.getAccessToken();
  expect(authToken, isNotNull, reason: 'El auth token en el storageSaver no debe ser null');
  expect(authToken, fakeAuthToken, reason: 'El auth token en el storageSaver debe ser igual al creado en este test');
}

void _testRemoveAuthToken(){
  test(descriptions.testRemoveAuthTokenDescription, ()async{
    try{
      await _tryTestRemoveAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveAuthToken()async{
  await UserStorageManager.removeAuthToken();
}

void _testSetUserInformation(){
  test(descriptions.testSetUserInformation, ()async{
    try{
      await _tryTestSetUserInformation();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future _tryTestSetUserInformation()async{
  await UserStorageManager.setUserInformation(fakeUserInformation['email'], fakeUserInformation['password']);
}

void _testGetUserInformation(){
  test(descriptions.testGetUserInformation, ()async{
    try{
      await _tryTestGetUserInformation();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future _tryTestGetUserInformation()async{
  final Map<String, dynamic> userInfo = await UserStorageManager.getUserInformation();
  expect(userInfo, isNotNull);
  expect(userInfo['email'], fakeUserInformation['email']);
  expect(userInfo['password'], fakeUserInformation['password']);
}