import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';

abstract class VisitsRemoteDataSource{
  Future<List<VisitModel>> getVisits(int projectId, String accessToken);
}

class VisitsRemoteDataSourceImpl extends RemoteDataSource implements VisitsRemoteDataSource{
  static const VISITS_API_URL = 'getvisitas/proyecto';
  final http.Client client;

  VisitsRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<List<VisitModel>> getVisits(int projectId, String accessToken)async{
    try{
      final Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
      final response = await client.get(
        Uri.http(super.BASE_URL, '${super.BASE_PANEL_UNCODED_PATH}$VISITS_API_URL/$projectId'),
        headers: headers
      );
      if(response.statusCode != 200)
        throw Exception();
      final dynamic responseBody = jsonDecode( response.body );
      return visitsFromRemoteJson(responseBody);
    }catch(exception){
      throw ServerException();
    }
  }
}