import 'dart:convert';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

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
    MuestreoModel tMuestra;
    Map<String, String> tHeaders;

    setUp((){
      tAccessToken = 'access_token';
      tVisitId = 1;
      tStringMuestra = callFixture('muestra.json');
      tJsonMuestra = jsonDecode(tStringMuestra);
      tMuestra = MuestreoModel.fromJson(tJsonMuestra);
      tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
    });

    test('should get the muestra from the client, using the specified headers', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 200));
      await dataSource.getMuestra(tAccessToken, tVisitId);
      verify(client.get(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.GET_MUESTREO_URL}$tVisitId'),
        headers: tHeaders
      ));
    });

    test('should return the muestra when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 200));
      final muestra = await dataSource.getMuestra(tAccessToken, tVisitId);
      print('muestreoooooooooooooooosssss: $muestra \n $tMuestra');
      expect(muestra, tMuestra);
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 303));
      final call = dataSource.getMuestra;
      expect(()=>call(tAccessToken, tVisitId), throwsA(TypeMatcher<ServerException>()));
    });

  });

  group('setMuestra', (){
    String tAccessToken;
    int tVisitId;
    MuestreoModel tMuestra;
    int tSelectedRangoIndex;
    Map<String, String> tHeaders;
    Map<String, dynamic> tBody;
    List<double> tPesosTomados;
    setUp((){
      tAccessToken = 'access_token';
      tVisitId = 1;
      tMuestra = MuestreoModel.fromJson( jsonDecode( callFixture('muestra.json') ) );
      tSelectedRangoIndex = 0;
      tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
      tPesosTomados = [];
      for(int i = 0; i < tMuestra.componentes.length; i++){
        tPesosTomados.add(i.toDouble());
      }
      tBody = {
        'tipo_rango':tSelectedRangoIndex, 
        'pesos':tPesosTomados,
        'visita_id':tVisitId
      };
    });

    test('should set the data on the client. ', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      await dataSource.setMuestra(tAccessToken, tVisitId, tSelectedRangoIndex, tPesosTomados);
      verify(client.post(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.SET_MUESTRA_URL}$tVisitId'),
        headers: tHeaders,
        body: jsonEncode( tBody )
      ));
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('ha ocurrio algo malo', 303));
      final call = dataSource.setMuestra;
      expect(()=>call(tAccessToken, tVisitId, tSelectedRangoIndex, tPesosTomados), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('updateMuestra', (){
    String tAccessToken;
    int tVisitId;
    int tMuestraIndexEnMuestreo;
    MuestraModel tMuestra;
    List<double> tPesosTomados;
    Map<String, String> tHeaders;
    Map<String, dynamic> tBody;
    setUp((){
      tAccessToken = 'access_token';
      tVisitId = 1;
      tMuestraIndexEnMuestreo = 0;
      tMuestra = MuestreoModel.fromJson( jsonDecode( callFixture('muestra.json') ) ).muestrasTomadas[tMuestraIndexEnMuestreo];
      tPesosTomados = tMuestra.pesos.map((p) => 0.5).toList();
      tHeaders = {'Authorization': 'Bearer $tAccessToken', 'Content-Type': 'application/json'};
      tBody = {
        'pesos': tPesosTomados,
        'index_muestra': tMuestraIndexEnMuestreo
      };
    });

    test('should call the client update method with the specified url, headers, body', ()async{
      when(client.put(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      await dataSource.updateMuestra(tAccessToken, tVisitId, tMuestraIndexEnMuestreo, tPesosTomados);
      verify(client.put(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.UPDATE_MUESTRA_URL}$tVisitId'),
        headers: tHeaders,
        body: jsonEncode(tBody)
      ));
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.put(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('ha ocurrio algo malo', 303));
      final call = dataSource.updateMuestra;
      expect(()=>call(tAccessToken, tVisitId, tMuestraIndexEnMuestreo, tPesosTomados), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('removeMuestra', (){
    String tAccessToken;
    int tMuestraId;
    Map<String, String> tHeaders;
    setUp((){
      tAccessToken = 'access_token';
      tMuestraId = 2;
      tHeaders = {'Authorization': 'Bearer $tAccessToken'};
    });
    
    test('should call the client delete method with the specified uri, headers and body', ()async{
      when(client.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 200));
      await dataSource.removeMuestra(tAccessToken, tMuestraId);
      verify(client.delete(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.REMOVE_MUESTRA_URL}$tMuestraId'),
        headers: tHeaders
      ));
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('ha ocurrio algo malo', 303));
      final call = dataSource.removeMuestra;
      expect(()=>call(tAccessToken, tMuestraId), throwsA(TypeMatcher<ServerException>()));
    });
  });
}