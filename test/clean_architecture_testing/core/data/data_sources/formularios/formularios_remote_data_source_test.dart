import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

FormulariosRemoteDataSourceImpl remoteDataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    remoteDataSource = FormulariosRemoteDataSourceImpl(
      client: client
    );
  });

  _testGetFormulariosGroup();
  _testGetChosenFormularioGroup();
  _testSetInitialPositionGroup();
  _testSetFirmerGroup();
  

}

void _testGetFormulariosGroup(){
  group('getFormularios', (){
    String tAccessToken;
    int tVisitId;
    String tStringFormularios;
    List<Map<String, dynamic>> tJsonFormularios;
    List<FormularioModel> tFormularios;
    setUp((){
      tAccessToken = 'access_token';
      tVisitId = 1;

      tStringFormularios = callFixture('formularios.json');
      tJsonFormularios = jsonDecode(tStringFormularios).cast<Map<String, dynamic>>();
      tFormularios = formulariosFromJson(tJsonFormularios);
    });

    test('should get the formularios from the client, using the api uri, and with the tHeaders', ()async{
      Map<String, String> tHeaders = {'Authorization': 'Bearer $tAccessToken', 'Content-Type':'application/json'};
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringFormularios, 200));
      await remoteDataSource.getFormularios(tVisitId, tAccessToken);
      verify(client.get(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_PANEL_UNCODED_PATH}${FormulariosRemoteDataSourceImpl.FORMULARIOS_URL}$tVisitId'),
        headers: tHeaders
      ));
    });

    test('should return the tFormularios successfuly when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringFormularios, 200));
      final List<FormularioModel> formularios = await remoteDataSource.getFormularios(tVisitId, tAccessToken);
      expect(formularios, tFormularios);
    });

    test('should throw a ServerException when status code is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringFormularios, 500));
      final call = remoteDataSource.getFormularios;
      expect(()=>call(tVisitId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });

    test('should throw a ServerException when body is not json', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Esta vaina no es un json', 200));
      final call = remoteDataSource.getFormularios;
      expect(()=>call(tVisitId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

void _testGetChosenFormularioGroup(){
  group('getChosenFormulario', (){
    String tAccessToken;
    FormularioModel tFormulario;
    String tStringFormulario;
    setUp((){
      tAccessToken = 'access_token';
      tFormulario = _getFormularioFromFixture();
      tStringFormulario = jsonEncode( tFormulario.toJson() );
    });

    test('should get the chosenFormulario from the client, using the specified uri and the tHeaders', ()async{
      Map<String, String> tHeaders = {'Authorization': 'Bearer $tAccessToken', 'Content-Type':'application/json'};
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringFormulario, 200));
      await remoteDataSource.getChosenFormulario(tFormulario.id, tAccessToken);
      verify(client.get(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_PANEL_UNCODED_PATH}${FormulariosRemoteDataSourceImpl.CHOSEN_FORMULARIO_URL}${tFormulario.id}'),
        headers: tHeaders
      ));
    });

    test('should return the tFormulario when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringFormulario, 200));
      final FormularioModel formulario = await remoteDataSource.getChosenFormulario(tFormulario.id, tAccessToken);
      expect(formulario, tFormulario);
    });

    test('should throw a ServerException when status code is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringFormulario, 500));
      final call = remoteDataSource.getChosenFormulario;
      expect(()=>call(tFormulario.id, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });

    test('should throw a ServerException when body is not json', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Esta vaina no es un json', 200));
      final call = remoteDataSource.getChosenFormulario;
      expect(()=>call(tFormulario.id, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

FormularioModel _getFormularioFromFixture(){
  String stringFormularios = callFixture('formularios.json');
  List<Map<String, dynamic>> jsonFormularios = jsonDecode(stringFormularios).cast<Map<String, dynamic>>();
  List<FormularioModel> formularios = formulariosFromJson(jsonFormularios);
  return formularios[0];
}

void _testSetInitialPositionGroup(){
  group('setInitialPosition', (){
    String tAccessToken;
    int tFormularioId;
    CustomPositionModel tPosition;
    setUp((){
      tAccessToken = 'access_token';
      FormularioModel formulario = _getFormularioFromFixture();
      tFormularioId = formulario.id;
      tPosition = formulario.initialPosition;
    });

    test('should set the initial position to the client, using the tHeaders and the tFormularioId in the uri', ()async{
      final Map<String, String> tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
      final Map<String, dynamic> tBody = {'latitud_inicio':tPosition.latitude, 'longitud_inicio':tPosition.longitude};
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      await remoteDataSource.setInitialPosition(tPosition, tFormularioId, tAccessToken);
      verify(client.post(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_PANEL_UNCODED_PATH}${FormulariosRemoteDataSourceImpl.INITIAL_POSITION_URL}$tFormularioId'),
        headers: tHeaders,
        body: tBody
      ));
    });

    test('should throw ServerException when statusCode is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 440));
      final call = remoteDataSource.setInitialPosition;
      expect(()=>call(tPosition, tFormularioId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
      
    });

    test('should throw a ServerException when body is not json', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Esta vaina no es un json', 200));
      final call = remoteDataSource.setInitialPosition;
      expect(()=>call(tPosition, tFormularioId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

void _testSetFirmerGroup(){
  //TODO: Implementar testing para este tipo de servicio. Hasta el momento no he podido.
}