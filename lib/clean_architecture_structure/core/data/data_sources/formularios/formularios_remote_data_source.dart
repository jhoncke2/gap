import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';

abstract class FormulariosRemoteDataSource{
  Future<List<FormularioModel>> getFormularios(int visitId, String accessToken);
  Future<FormularioModel> getChosenFormulario(int formularioId, String accessToken);
  Future<void> setInitialPosition(CustomPositionModel position, int formularioId, String accessToken);
  Future<void> setCampos(FormularioModel formulario, int visitId, String accessToken);
  Future<void> setFinalPosition(CustomPositionModel position, int formularioId, String accessToken);
  Future<void> setFirmer(FirmerModel firmer, int formularioId, int visitId, String accessToken);
}

class FormulariosRemoteDataSourceImpl extends RemoteDataSourceWithMultiPartRequests implements FormulariosRemoteDataSource{
  static const FORMULARIOS_URL = 'getformularios/visita/';
  static const CHOSEN_FORMULARIO_URL = 'getformulario/visita/';
  static const INITIAL_POSITION_URL = 'formulario/inicia/';
  static const CAMPOS_URL = 'visita-respuestas/';
  static const FINAL_POSITION_URL = 'formulario/final/';
  static const FIRMER_URL = 'visita-firmas/';
  final http.Client client;

  FormulariosRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<List<FormularioModel>> getFormularios(int visitId, String accessToken)async{
    return await _executeService(()async{
      final response = await client.get(
        Uri.http(super.BASE_URL, '${super.BASE_PANEL_UNCODED_PATH}$FORMULARIOS_URL$visitId'),
        headers: _createAuthorizationHeaders(accessToken)
      );
      if(response.statusCode != 200)
        throw Exception();
      final List<Map<String, dynamic>> jsonFormularios = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return formulariosFromJson(jsonFormularios);
    });
  }

  @override
  Future<FormularioModel> getChosenFormulario(int formularioId, String accessToken)async{
    return await _executeService(()async{
      final response = await client.get(
        Uri.http(super.BASE_URL, '${super.BASE_PANEL_UNCODED_PATH}$CHOSEN_FORMULARIO_URL$formularioId'),
        headers: _createAuthorizationHeaders(accessToken)
      );
      if(response.statusCode != 200)
        throw Exception();
      final Map<String, dynamic> jsonFormulario = jsonDecode(response.body);
      return FormularioModel.fromJson(jsonFormulario);
    });
  }

  @override
  Future<void> setInitialPosition(CustomPositionModel position, int formularioId, String accessToken)async{
    await _executeService(()async{
      final Map<String, dynamic> body = {
        'latitud_inicio':position.latitude,
        'longitud_inicio':position.longitude
      };
      final response = await client.post(
        Uri.http(super.BASE_URL, '${super.BASE_PANEL_UNCODED_PATH}$INITIAL_POSITION_URL$formularioId'),
        headers: _createAuthorizationHeaders(accessToken),
        body: body
      );
      if(response.statusCode != 200)
        throw ServerException();
    });
  }

  @override
  Future<void> setCampos(FormularioModel formulario, int visitId, String accessToken)async{
    // TODO: implement setFormulario
    throw UnimplementedError();
  }

  @override
  Future<void> setFinalPosition(CustomPositionModel position, int formularioId, String accessToken)async{
    // TODO: implement setFinalPosition
    throw UnimplementedError();
  }

  @override
  Future<void> setFirmer(FirmerModel firmer, int formularioId, int visitId, String accessToken)async{
    _executeService(()async{
      final String requestUrl = '${super.BASE_URL}/${super.BASE_PANEL_UNCODED_PATH}$FIRMER_URL$visitId';
      final Map<String, String> headers = {'Authorization':'Bearer $accessToken', 'Content-Type':'application/x-www-form-urlencoded'};
      final Map<String, String> fields = firmer.toServiceJson();
      fields['formulario_visita_id'] = formularioId.toString();
      final Map<String, dynamic> fileInfo = {
        'field_name':'photo',
        'file':firmer.firm
      };
      final response = await executeMultiPartRequestWithOneFile(requestUrl, headers, fields, fileInfo);
      if(response.statusCode != 200)
        throw Exception();
    });
  }

  Map<String, String> _createAuthorizationHeaders(String accessToken){
    return {
      'Authorization':'Bearer $accessToken',
      'Content-Type':'application/json'
    };
  }

  Future<dynamic> _executeService(
    Future<dynamic> Function() function
  )async{
    try{
      return await function();
    }catch(exception){
      throw ServerException();
    }
  }
}