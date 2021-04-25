import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

VisitsRemoteDataSourceImpl remoteDataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    remoteDataSource = VisitsRemoteDataSourceImpl(
      client: client
    );
  });

  group('getVisits', (){
    String tAccessToken;
    int tProjectId;
    Map<String, String> tHeaders;
    String tStringVisits;
    List<Map<String, dynamic>> tJsonVisits;
    List<VisitModel> tVisits;

    setUp((){
      tAccessToken = 'access_token';
      tProjectId = 1;
      tHeaders = {'Authorization': 'Bearer $tAccessToken'};
      tStringVisits = callFixture('visits.json');
      tJsonVisits = jsonDecode(tStringVisits).cast<Map<String, dynamic>>();
      tVisits = visitsFromRemoteJson(tJsonVisits); 
    });

    test('should get the visits from the client using the tHeaders', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringVisits, 200));
      await remoteDataSource.getVisits(tProjectId, tAccessToken);
      verify(client.get(
        Uri.http(remoteDataSource.BASE_URL, '${VisitsRemoteDataSourceImpl.VISITS_API_URL}/$tProjectId'),
        headers: tHeaders
      ));
    });

    test('should return tVisits when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringVisits, 200));
      final List<VisitModel> visits = await remoteDataSource.getVisits(tProjectId, tAccessToken);
      expect(visits, equals(tVisits));
    });

    test('should throw ServerException when client return response with statusCode != 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringVisits, 500));
      final call = remoteDataSource.getVisits;
      expect(()=>call(tProjectId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });

    test('should throw ServerException when client return response with nonJson body', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Ha habido un problema grave. Dímelo tú.', 200));
      final call = remoteDataSource.getVisits;
      expect(()=>call(tProjectId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}