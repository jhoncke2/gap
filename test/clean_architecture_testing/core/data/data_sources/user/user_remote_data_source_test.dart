import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

UserRemoteDataSourceImpl remoteDataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    remoteDataSource = UserRemoteDataSourceImpl(
      client: client
    );
  });

  group('login', (){
    String tAccessToken;
    String tStringUser;
    Map<String, dynamic> tJsonUser;
    UserModel tUser;
    Map<String, dynamic> tResponseBody;
    setUp((){
      tAccessToken = 'access_token';
      tStringUser = callFixture('user.json');
      tJsonUser = jsonDecode(tStringUser);
      tUser = UserModel.fromJson(tJsonUser);
      tResponseBody = {
        "data": {
            "headers": {},
            "original": {
                "access_token": tAccessToken,
                "token_type": "bearer",
                "expires_in": 36000
            },
            "exception": null
        }
      };
    });

    test('should get the login on the client, usnig the tJsonUser as body and the specified uri', ()async{
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(jsonEncode(tResponseBody), 200));
      await remoteDataSource.login(tUser);
      verify(client.post(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_AUTH_UNCODED_PATH}${UserRemoteDataSourceImpl.LOGIN_URL}'),
        body: tJsonUser
      ));
    });

    test('should return the tAccessToken when all goes good', ()async{
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(jsonEncode(tResponseBody), 200));
      final accessToken = await remoteDataSource.login(tUser);
      expect(accessToken, equals(tAccessToken));
    });

    test('should throw ServerException(LOGIN) when response status code is not 200', ()async{
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(jsonEncode(tResponseBody), 303));
      try{
        await remoteDataSource.login(tUser);
        fail('debería haber lanzado un ServerException');
      }on ServerException catch(exception){
        expect(exception.type, ServerExceptionType.LOGIN);
      }
    });

    test('should throw ServerException(LOGIN) when response body is not json', ()async{
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('pos, no soy un json', 200));
      try{
        await remoteDataSource.login(tUser);
        fail('debería haber lanzado un ServerException');
      }on ServerException catch(exception){
        expect(exception.type, ServerExceptionType.LOGIN);
      }
    });
  });

  group('refreshAccessToken', (){
    String tOldAccessToken;
    Map<String, dynamic> tResponseBody;
    String tNewAccessToken;
    setUp((){
      tOldAccessToken = 'old_access_token';
      tResponseBody = {
        "data": {
          "headers": {},
          "original": {
              "access_token": tNewAccessToken,
              "token_type": "bearer",
              "expires_in": 36000
          },
          "exception": null
        }
      };
      tNewAccessToken = 'new_access_token';
    });

    test('should post the oldAccess token on the client, using the specified body', ()async{
      final Map<String, String> tHeaders = {'Authorization':'Bearer $tOldAccessToken', 'Content-Type':'application/json'};
      when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonEncode(tResponseBody), 200));
      await remoteDataSource.refreshAccessToken(tOldAccessToken);
      verify(client.post(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_AUTH_UNCODED_PATH}${UserRemoteDataSourceImpl.REFRESH_ACCESS_TOKEN_URL}'),
        headers: tHeaders
      ));
    });

    test('should return the tAccessToken when all goes good', ()async{
      when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonEncode(tResponseBody), 200));
      final String newAccessToken = await remoteDataSource.refreshAccessToken(tOldAccessToken);
      expect(newAccessToken, equals(tNewAccessToken));
    });
  });
}