import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/general/remote_data_source.dart';

abstract class MuestrasRemoteDataSource{
  Future<MuestraModel> getMuestra(String accessToken, int visitId);
  Future<MuestraModel> setMuestra(String accessToken, int visitId, MuestraModel muestra);
}

class MuestrasRemoteDataSourceImpl extends RemoteDataSource implements MuestrasRemoteDataSource{
  static const GET_MUESTRA_URL = 'getformatomuestra/visita/';

  final http.Client client;

  MuestrasRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<MuestraModel> getMuestra(String accessToken, int visitId)async{
    final Map<String, String> headers = super.createAuthorizationJsonHeaders(accessToken);
    final response = await executeGeneralService(()async{
      return await client.get(
        super.getUri('${super.BASE_PANEL_UNCODED_PATH}$GET_MUESTRA_URL$visitId'),
        headers: headers
      );
    });
    
    
    final Map<String, dynamic> jsonMuestra = jsonDecode(response.body);
    return MuestraModel.fromJson(jsonMuestra);
  }

  @override
  Future<MuestraModel> setMuestra(String accessToken, int visitId, MuestraModel muestra)async{
    // TODO: implement setMuestra
    throw UnimplementedError();
  }
  
}