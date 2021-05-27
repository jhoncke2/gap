import 'dart:convert';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/select.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
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
  _testSetCamposGroup();
  _testSetFinalPositionGroup();
  _testSetFirmerGroup();
}

List<CustomFormFieldOld> _getFormFieldsFromFixture(){
  final String stringFormFields = callFixture('formulario_campos.json');
  final List<Map<String, dynamic>> jsonFormFields = jsonDecode(stringFormFields).cast<Map<String, dynamic>>();
  final List<CustomFormFieldOld> formFields = customFormFieldsFromJson(jsonFormFields);
  return formFields;
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
      final Map<String, dynamic> tJsonFormularioResponse = {};
      tJsonFormularioResponse['data'] = jsonDecode(tStringFormulario);
      tStringFormulario = jsonEncode(tJsonFormularioResponse);
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
        body: jsonEncode(tBody)
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

void _testSetCamposGroup(){
  group('setCampos', (){
    String tAccessToken;
    int tVisitId;
    FormularioModel tFormulario;
    //TODO: Cambiar por nueva versión de CustomFormField
    List<CustomFormFieldOld> tFormFields;
    setUp((){
      tAccessToken = 'access_token';
      tVisitId = 1;
      tFormulario = _getFormularioFromFixture();
      tFormFields = _getFormFieldsFromFixture();
      tFormulario = tFormulario.copyWith(campos: tFormFields);
    });

    test('should post the formatted data in client, using the tHeader, and the tFormularioId on the uri', ()async{
      final Map<String, String> tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
      Map<String, dynamic> tBody = {
        'respuestas':[
          {
            "formulario_visita_id":tFormulario.id,
            "name":(tFormFields[0] as NumberFormFieldOld).name,
            "res":[(tFormFields[0] as NumberFormFieldOld).uniqueValue.toString()]
          },
          {
            "formulario_visita_id":tFormulario.id,
            "name":(tFormFields[1] as DateFieldOld).name,
            "res":[(tFormFields[1] as DateFieldOld).uniqueValue]
          },
          {
            "formulario_visita_id":tFormulario.id,
            "name":(tFormFields[2] as SelectFormFieldOld).name,
            "res":[1,0,0,0]
          },
          {
            "formulario_visita_id":tFormulario.id,
            "name":(tFormFields[3] as RawTextFormFieldOld).name,
            "res":[(tFormFields[3] as RawTextFormFieldOld).uniqueValue]
          },
          {
            "formulario_visita_id":tFormulario.id,
            "name":(tFormFields[4] as CheckBoxGroupOld).name,
            "res":[1,1,1,0,0]
          }
        ]
      };
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((realInvocation) async => http.Response('{}', 200));
      await remoteDataSource.setCampos(tFormulario, tVisitId, tAccessToken);
      verify(client.post(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_PANEL_UNCODED_PATH}${FormulariosRemoteDataSourceImpl.CAMPOS_URL}$tVisitId'),
        headers: tHeaders,
        body: jsonEncode(tBody)
      ));
    });

    test('should throw a ServerException when the response status code is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((realInvocation) async => http.Response('{}', 345));
      final call = remoteDataSource.setCampos;
      expect(()=>call(tFormulario, tVisitId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });

    test('should throw a ServerException when the response body is not json', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((realInvocation) async => http.Response('wenas', 200));
      final call = remoteDataSource.setCampos;
      expect(()=>call(tFormulario, tVisitId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

void _testSetFinalPositionGroup(){
  group('setFinalPosition', (){
    String tAccessToken;
    int tFormularioId;
    CustomPositionModel tPosition;
    setUp((){
      tAccessToken = 'access_token';
      FormularioModel formulario = _getFormularioFromFixture();
      tFormularioId = formulario.id;
      tPosition = formulario.initialPosition;
    });

    test('should set the final position to the client, using the tHeaders and the tFormularioId in the uri', ()async{
      final Map<String, String> tHeaders = {'Authorization':'Bearer $tAccessToken', 'Content-Type':'application/json'};
      final Map<String, dynamic> tBody = {'latitud_final':tPosition.latitude, 'longitud_final':tPosition.longitude};
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      await remoteDataSource.setFinalPosition(tPosition, tFormularioId, tAccessToken);
      verify(client.post(
        Uri.http(remoteDataSource.BASE_URL, '${remoteDataSource.BASE_PANEL_UNCODED_PATH}${FormulariosRemoteDataSourceImpl.FINAL_POSITION_URL}$tFormularioId'),
        headers: tHeaders,
        body: jsonEncode(tBody)
      ));
    });

    test('should throw ServerException when statusCode is not 200', ()async{
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 440));
      final call = remoteDataSource.setFinalPosition;
      expect(()=>call(tPosition, tFormularioId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
      
    });

    test('should throw a ServerException when body is not json', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Esta vaina no es un json', 200));
      final call = remoteDataSource.setFinalPosition;
      expect(()=>call(tPosition, tFormularioId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}

void _testSetFirmerGroup(){
  //TODO: Implementar testing para este tipo de servicio. Hasta el momento no he podido.
}