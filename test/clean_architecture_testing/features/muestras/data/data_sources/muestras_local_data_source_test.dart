import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

MuestrasRemoteDataSourceImpl dataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    dataSource = MuestrasRemoteDataSourceImpl(
      client: client
    );
  });

  group('getMuestra', (){
    String tAccessToken;
    int tVisitId;
    String tStringMuestra;
    Map<String, dynamic> tJsonMuestra;
    MuestraModel tMuestra;
    Map<String, String> tHeaders;

    setUp((){
      tAccessToken = 'access_token';
      tVisitId = 1;
      tStringMuestra = callFixture('muestra.json');
      tJsonMuestra = jsonDecode(tStringMuestra);
      tMuestra = MuestraModel.fromJson(tJsonMuestra);
      tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
    });

    test('should get the muestra from the client, using the specified headers', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 200));
      await dataSource.getMuestra(tAccessToken, tVisitId);
      verify(client.get(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.GET_MUESTRA_URL}$tVisitId'),
        headers: tHeaders
      ));
    });

    test('should return the muestra when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 200));
      final muestra = await dataSource.getMuestra(tAccessToken, tVisitId);
      expect(muestra, tMuestra);
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response(tStringMuestra, 303));
      final call = dataSource.getMuestra;
      expect(()=>call(tAccessToken, tVisitId), throwsA(TypeMatcher<ServerException>()));
    });

  });
}
