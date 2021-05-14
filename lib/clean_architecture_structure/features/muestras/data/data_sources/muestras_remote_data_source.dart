import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/general/remote_data_source.dart';

abstract class MuestrasRemoteDataSource{
  Future<MuestreoModel> getMuestra(String accessToken, int visitId);
  Future<void> setMuestra(String accessToken, int visitId, int selectedRangoIndex, List<double> pesosTomados);
}

class MuestrasRemoteDataSourceImpl extends RemoteDataSource implements MuestrasRemoteDataSource{
  static const GET_MUESTRA_URL = 'getformatomuestra/visita/';
  static const SET_MUESTRA_URL = 'setformatomuestra/visita/';

  final http.Client client;

  MuestrasRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<MuestreoModel> getMuestra(String accessToken, int visitId)async{
    final Map<String, String> headers = super.createAuthorizationJsonHeaders(accessToken);
    final response = await executeGeneralService(()async{
      return await client.get(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$GET_MUESTRA_URL$visitId'),
        headers: headers
      );
    }); 
    final Map<String, dynamic> jsonMuestra = jsonDecode(response.body);
    return MuestreoModel.fromJson(jsonMuestra);
  }

  @override
  Future<void> setMuestra(String accessToken, int visitId, int selectedRangoIndex, List<double> pesosTomados)async{
    Map<String, dynamic> body = {
      'tipo_rango':selectedRangoIndex,
      'pesos':pesosTomados
    };
    body['visita_id'] = visitId;
    await executeGeneralService(()async=>
      await client.post(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$SET_MUESTRA_URL$visitId'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode( body )
      )
    );
  }
}