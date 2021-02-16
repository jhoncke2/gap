import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import './user_storage_manager_descriptions.dart' as descriptions;

final String fakeAuthToken = 'fake_auth_token';

void main(){
  _initStorageConnector();
  group(descriptions.authTokenGroupDescription, (){
    _testSetAuthToken();
    _testGetAuthToken();
    _testRemoveAuthToken();    
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
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
  await UserStorageManager.setAuthToken(fakeAuthToken);
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
  final String authToken = await UserStorageManager.getAuthToken();
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