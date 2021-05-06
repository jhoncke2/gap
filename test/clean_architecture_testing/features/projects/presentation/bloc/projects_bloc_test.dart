import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetProjects extends Mock implements GetProjects{}

MockGetProjects useCase;
ProjectsBloc bloc;

void main(){
  setUp((){
    useCase = MockGetProjects();
    bloc = ProjectsBloc(
      getProjects: useCase
    );
  });

  group('loadProjects', (){
    List<Project> tProjects;
    setUp((){
      tProjects = _getProjectsFromFixture();
    });

    test('should call the useCase', ()async{
      when(useCase.call(any)).thenAnswer((_) async => Right(tProjects));
      bloc.add(LoadProjects());
      await untilCalled(useCase.call(any));
      verify(useCase.call(NoParams()));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(useCase.call(any)).thenAnswer((_) async => Right(tProjects));
      final expectedOrderedStates = [
        LoadedProjects(projects: tProjects)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadProjects());
    });

    test('should yield the specified ordered states when usecase returns Left(ServerFailure(X))', ()async{
      String errorMessage = 'error, pues';
      when(useCase.call(any)).thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));
      final expectedOrderedStates = [
        ErrorProjects(message: errorMessage)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadProjects());
    });

    test('should yield the specified ordered states when usecase returns Left(Failure(X))', ()async{
      when(useCase.call(any)).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      final expectedOrderedStates = [
        ErrorProjects(message: ProjectsBloc.GENERAL_ERROR_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadProjects());
    });
  });
}

List<Project> _getProjectsFromFixture(){
  String stringProjects = callFixture('projects.json');
  List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  List<Project> projects = projectsFromRemoteJson(jsonProjects);
  return projects;
}