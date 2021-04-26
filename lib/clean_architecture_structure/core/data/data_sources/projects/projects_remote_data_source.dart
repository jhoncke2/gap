import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';

abstract class ProjectsRemoteDataSource{
  Future<List<ProjectModel>> getProjects(String accessToken);
}

class ProjectsRemoteDataSourceImpl extends RemoteDataSource implements ProjectsRemoteDataSource{
  static const PROJECTS_API_URL = 'getproyectos';
  final http.Client client;

  ProjectsRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<List<ProjectModel>> getProjects(String accessToken)async{
    try{
      final Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
      final response = await client.get(
        Uri.http(BASE_URL, '${super.BASE_PANEL_UNCODED_PATH}$PROJECTS_API_URL'),
        headers: headers
      );
      if(response.statusCode != 200)
        throw Exception();
      final dynamic jsonProjects = jsonDecode(response.body);
      return projectsFromRemoteJson(jsonProjects);
    }catch(exception){
      throw ServerException();
    }
  }
}