import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

ProjectsRemoteDataSourceImpl remoteDataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    remoteDataSource = ProjectsRemoteDataSourceImpl(
      client: client
    );
  });

  group('getProjects', (){
    String tAccessToken;
    Map<String, String> tHeaders;
    String tStringProjects;
    List<Map<String, dynamic>> tJsonProjects;
    List<ProjectModel> tProjects;
    setUp((){
      tAccessToken = 'access_token';
      tHeaders = {
        'Authorization':'Bearer $tAccessToken'
      };
      tStringProjects = callFixture('projects.json');
      tJsonProjects = jsonDecode(tStringProjects).cast<Map<String, dynamic>>();
      tProjects = projectsFromRemoteJson(tJsonProjects);
    });

    test('should get the projects from the client, with the tHeaders', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response(tStringProjects, 200));
      await remoteDataSource.getProjects(tAccessToken);
      verify(client.get(
        Uri.http(remoteDataSource.BASE_URL, ProjectsRemoteDataSourceImpl.PROJECTS_API_URL),
        headers: tHeaders
      ));
    });

    test('should return the tProjects when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response(tStringProjects, 200));
      final List<ProjectModel> projects = await remoteDataSource.getProjects(tAccessToken);
      expect(projects, tProjects);
    });

    test('should return the tProjects when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response(tStringProjects, 200));
      final List<ProjectModel> projects = await remoteDataSource.getProjects(tAccessToken);
      expect(projects, tProjects);
    });

    test('should throws a ServerException when the http response has a status code that is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response(tStringProjects, 303));
      final call = remoteDataSource.getProjects;
      expect(()=>call(tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });

    test('should throws a ServerException when the http response has a nonJson body', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response('Se ha detectado una amenaza', 200));
      final call = remoteDataSource.getProjects;
      expect(()=>call(tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}