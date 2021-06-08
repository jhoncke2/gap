import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
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
      tStringMuestra = callFixture('muestreo.json');
      tJsonMuestra = jsonDecode(tStringMuestra);
      tMuestra = MuestreoModel.fromRemoteJson(tJsonMuestra);
      tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
    });

    test('should get the muestra from the client, using the specified headers', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 200));
      await dataSource.getMuestreo(tAccessToken, tVisitId);
      verify(client.get(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.GET_MUESTREO_URL}$tVisitId'),
        headers: tHeaders
      ));
    });

    test('should return the muestra when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 200));
      final muestra = await dataSource.getMuestreo(tAccessToken, tVisitId);
      print('muestreoooooooooooooooosssss: $muestra \n $tMuestra');
      expect(muestra, tMuestra);
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringMuestra, 303));
      final call = dataSource.getMuestreo;
      expect(()=>call(tAccessToken, tVisitId), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('updatePreparaciones', (){
    String tAccessToken;
    int tMuestreoId;
    List<String> tPreparaciones;
    Map<String, String> tHeaders;
    Map<String, dynamic> tBody;
    setUp((){
      tAccessToken = 'access_token';
      tMuestreoId = 1;
      tPreparaciones = ['prep1', 'prep2', 'prep3'];
      tHeaders = {'Authorization': 'Bearer $tAccessToken', 'Content-Type': 'application/json'};
      tBody = {
        'preparaciones': tPreparaciones
      };
    });

    test('should call the client update method with the specified url, headers, body', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      await dataSource.updatePreparaciones(tAccessToken, tMuestreoId, tPreparaciones);
      verify(client.post(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.UPDATE_PREPARACIONES_URL}$tMuestreoId'),
        headers: tHeaders,
        body: jsonEncode(tBody)
      ));
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('ha ocurrio algo malo', 303));
      final call = dataSource.updatePreparaciones;
      expect(()=>call(tAccessToken, tMuestreoId, tPreparaciones), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('setMuestra', (){
    String tAccessToken;
    int tMuestreoId;
    MuestreoModel tMuestra;
    int tSelectedRangoId;
    String tSelectedRango;
    Map<String, String> tHeaders;
    Map<String, dynamic> tBody;
    List<double> tPesosTomados;
    
    setUp((){
      tAccessToken = 'access_token';
      tMuestreoId = 1;
      tMuestra = MuestreoModel.fromRemoteJson( jsonDecode( callFixture('muestreo.json') ) );
      tSelectedRangoId = 1;
      tSelectedRango = 'selected_rango';
      tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
      tPesosTomados = [];
      for(int i = 0; i < tMuestra.componentes.length; i++){
        tPesosTomados.add(i.toDouble());
      }
      tBody = {
        'clasificacion_id':tSelectedRangoId,
        'respuesta':tPesosTomados
      };
    });

    test('should set the data on the client. ', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      await dataSource.setMuestra(tAccessToken, tMuestreoId, tSelectedRangoId, tPesosTomados);
      verify(client.post(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.SET_MUESTRA_URL}$tMuestreoId'),
        headers: tHeaders,
        body: jsonEncode( tBody )
      ));
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('ha ocurrio algo malo', 303));
      final call = dataSource.setMuestra;
      expect(()=>call(tAccessToken, tMuestreoId, tSelectedRangoId, tPesosTomados), throwsA(TypeMatcher<ServerException>()));
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

  group('post formulario', (){
    int tMuestreoId;
    String tAccessToken;
    FormularioModel tFormulario;
    String tFormularioType;
    setUp((){
      tMuestreoId = 1;
      tAccessToken = 'access_token';
      tFormulario = _getFormularioFromFixtres();
      tFormularioType = 'Pre';
    });

    test('should call the client post method with the specified url, headers, and body', ()async{
      Map<String, String> tHeaders = {'Authorization': 'Bearer $tAccessToken', 'Content-Type':'application/json'};
      Map<String, dynamic> tBody = {
        'tipo':tFormularioType,
        'respuestas':[]
      };
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async=> http.Response('{}', 200));
      await dataSource.setFormulario(tAccessToken, tMuestreoId, tFormulario, tFormularioType);
      verify(client.post(
        Uri.https(dataSource.BASE_URL, '${dataSource.BASE_PANEL_UNCODED_PATH}${MuestrasRemoteDataSourceImpl.SET_FORMULARIO_URL}$tMuestreoId'),
        headers: tHeaders,
        body: jsonEncode( tBody )
      ));
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('ha ocurrio algo malo', 303));
      final call = dataSource.setFormulario;
      expect(()=>call(tAccessToken, tMuestreoId, tFormulario, tFormularioType), throwsA(TypeMatcher<ServerException>()));
    });
  });

}

FormularioModel _getFormularioFromFixtres(){
  String sFormulario = callFixture('formularios.json');
  Map<String, dynamic> jFormulario = jsonDecode(sFormulario).cast<Map<String, dynamic>>()[0];
  return FormularioModel.fromJson(jFormulario);
}