import 'dart:convert';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';
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
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.GET_MUESTRA_URL}$tVisitId'),
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
        RangoToma rangoToma = tMuestra.componentes[i].valoresPorRango
          .singleWhere((rT) => rT.rango == tMuestra.rangos[tSelectedRangoIndex]);
        rangoToma.pesosTomados.add(i.toDouble());
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
}
