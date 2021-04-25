import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{}

UserLocalDataSourceImpl localDataSource;
MockStorageConnector storageConnector;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    localDataSource = UserLocalDataSourceImpl(
      storageConnector: storageConnector
    );
  });

  group('setUserInformation', (){
    String tStringUser;
    Map<String, dynamic> tJsonUser;
    UserModel tUser;
    setUp((){
      tStringUser = callFixture('user.json');
      tJsonUser = jsonDecode(tStringUser);
      tUser = UserModel.fromJson(tJsonUser);
    });

    test('should set the user information in the storageConnector', ()async{
      await localDataSource.setUserInformation(tUser);
      verify(storageConnector.setMap(tJsonUser, UserLocalDataSourceImpl.USER_STORAGE_KEY));
    });
  });

  group('getUserInformation', (){
    String tStringUser;
    Map<String, dynamic> tJsonUser;
    UserModel tUser;
    setUp((){
      tStringUser = callFixture('user.json');
      tJsonUser = jsonDecode(tStringUser);
      tUser = UserModel.fromJson(tJsonUser);
    });

    test('should get the user information from the storageConnector', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tJsonUser);
      await localDataSource.getUserInformation();
      verify(storageConnector.getMap(UserLocalDataSourceImpl.USER_STORAGE_KEY));
    });

    test('should return the tUser', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tJsonUser);
      final UserModel user = await localDataSource.getUserInformation();
      expect(user, equals(tUser));
    });
  });

  group('setAccessToken', (){
    String tAccessToken;
    setUp((){
      tAccessToken = 'access_token';
    });

    test('should set the access token on the storageConnector', ()async{
      await localDataSource.setAccessToken(tAccessToken);
      verify(storageConnector.setString(tAccessToken, UserLocalDataSourceImpl.ACCESS_TOKEN_STORAGE_KEY));
    });
  });

  group('getAccessToken', (){
    String tAccessToken;
    setUp((){
      tAccessToken = 'access_token';
    });

    test('should get the accessToken information from the storageConnector', ()async{
      when(storageConnector.getString(any)).thenAnswer((_) async => tAccessToken);
      await localDataSource.getAccessToken();
      verify(storageConnector.getString(UserLocalDataSourceImpl.ACCESS_TOKEN_STORAGE_KEY));
    });

    test('should return the tUser', ()async{
      when(storageConnector.getString(any)).thenAnswer((_) async => tAccessToken);
      final String accessToken = await localDataSource.getAccessToken();
      expect(accessToken, equals(tAccessToken));
    });
  });
}