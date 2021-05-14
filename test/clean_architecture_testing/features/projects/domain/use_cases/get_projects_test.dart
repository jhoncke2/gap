import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository{}

GetProjects useCase;
MockProjectsRepository repository;

void main(){
  setUp((){
    repository = MockProjectsRepository();
    useCase = GetProjects(repository: repository);
  });

  group('getProjects', (){
    List<Project> tProjects;
    setUp((){
      tProjects = _getProjectsFromFixture();
    });

    test('should call the repository get projects method', ()async{
      when(repository.getProjects()).thenAnswer((_) async => Right(tProjects));
      await useCase.call(NoParams());
      verify(repository.getProjects());
    });
  });
}

List<Project> _getProjectsFromFixture(){
  String stringProjects = callFixture('projects.json');
  List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  List<Project> projects = projectsFromRemoteJson(jsonProjects);
  return projects;
}