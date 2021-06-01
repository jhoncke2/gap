import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/general/remote_data_source.dart';

abstract class MuestrasRemoteDataSource{
  Future<MuestreoModel> getMuestreo(String accessToken, int visitId);
  Future<void> setFormulario(String accessToken, int muestreoId, FormularioModel formulario, String formularioTipo);
  Future<void> updatePreparaciones(String accessToken, int muestreoId, List<String> preparaciones);
  Future<void> setMuestra(String accessToken, int muestreoId, int selectedRangoId, List<double> pesosTomados);
  Future<void> removeMuestra(String accessToken, int muestraId);
}

class MuestrasRemoteDataSourceImpl extends RemoteDataSource implements MuestrasRemoteDataSource{
  static const GET_MUESTREO_URL = 'getformatomuestra/visita/';
  static const SET_FORMULARIO_URL = 'setformatomuestra/respuesta-pre-pos/';
  static const SET_MUESTRA_URL = 'setformatomuestra/respuesta/';
  static const UPDATE_PREPARACIONES_URL = 'setformatomuestra/preparacion/';
  static const REMOVE_MUESTRA_URL = 'getformatomuestra/respuesta-delete/';

  final http.Client client;

  MuestrasRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<MuestreoModel> getMuestreo(String accessToken, int visitId)async{
    final Map<String, String> headers = super.createAuthorizationJsonHeaders(accessToken);
    final response = await executeGeneralService(()async{
      return await client.get(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$GET_MUESTREO_URL$visitId'),
        headers: headers
      );
    }); 
    final Map<String, dynamic> jsonMuestra = jsonDecode(response.body);
    return MuestreoModel.fromJson(jsonMuestra);
  }

  @override
  Future<void> setFormulario(String accessToken, int muestreoId, FormularioModel formulario, String formularioTipo)async{
    Map<String, dynamic> body = {
      'tipo':formularioTipo,
      'respuestas': _getFormattedFormCampos(formulario)
    };
    await executeGeneralService(()async=>
      await client.post(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$SET_FORMULARIO_URL$muestreoId'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode( body )
      )
    );
  }

  static List<Map<String, dynamic>> _getFormattedFormCampos(FormularioModel formulario){
    final List<Map<String, dynamic>> jsonCampos = [];
    for(CustomFormFieldOld cff in formulario.campos)
      if(cff is VariableFormFieldOld)
        _addVariableFormFieldToList(cff, jsonCampos, formulario.id); 
    return jsonCampos;
  }

  static void _addVariableFormFieldToList(VariableFormFieldOld vff, List<Map<String, dynamic>> jsonCampos, int formId){
    final Map<String, dynamic> jsonCff = _getServiceJsonByVariableFormField(vff, formId);
    _defineFormFieldValuesByTypeOfValues(vff, jsonCff);
    jsonCampos.add(jsonCff);
  }

  static Map<String, dynamic> _getServiceJsonByVariableFormField(VariableFormFieldOld vff, int formId){
    return {
      'name': vff.name
    };
  }

  static void _defineFormFieldValuesByTypeOfValues(VariableFormFieldOld vff, Map<String, dynamic> jsonVff){
    if(vff is SingleValueFormFieldOld){
      jsonVff['res'] = [vff.uniqueValue??''];
    }else if(vff is MultiValueFormFieldOld){
      jsonVff['res'] = (vff.values.map<int>((item) => item.selected?1:0)).toList();
    }
  }

  @override
  Future<void> updatePreparaciones(String accessToken, int muestreoId, List<String> preparaciones)async{
    final Map<String, dynamic> body = {
      'preparaciones': preparaciones
    };
    await executeGeneralService(() async =>
      await client.post(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$UPDATE_PREPARACIONES_URL$muestreoId'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode(body)
      )
    );
  }

  @override
  Future<void> setMuestra(String accessToken, int muestreoId, int selectedRangoId, List<double> pesosTomados)async{
    Map<String, dynamic> body = {
      'clasificacion_id':selectedRangoId,
      'respuesta':pesosTomados
    };
    await executeGeneralService(()async=>
      await client.post(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$SET_MUESTRA_URL$muestreoId'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode( body )
      )
    );
  }

  @override
  Future<void> removeMuestra(String accessToken, int muestraId)async{
    await executeGeneralService(()async=>
      await client.delete(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$REMOVE_MUESTRA_URL$muestraId'),
        headers: super.createSingleAuthorizationHeaders(accessToken)
      )
    );
  }
}