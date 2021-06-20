import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/set_chosen_project.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_chosen_project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetProjects extends Mock implements GetProjects{}
class MockGetChosenProject extends Mock implements GetChosenProject{}
class MockSetChosenProject extends Mock implements SetChosenProject{}

MockGetProjects getProjects;
MockGetChosenProject getChosenProject;
MockSetChosenProject setChosenProject;
ProjectsBloc bloc;

void main(){
  setUp((){
    getProjects = MockGetProjects();
    getChosenProject = MockGetChosenProject();
    setChosenProject = MockSetChosenProject();
    bloc = ProjectsBloc(
      getProjects: getProjects,
      getChosenProject: getChosenProject,
      setChosenProject: setChosenProject
    );
  });

  group('loadProjects', (){
    List<Project> tProjects;
    setUp((){
      tProjects = _getProjectsFromFixture();
    });

    test('should call the useCase', ()async{
      when(getProjects.call(any)).thenAnswer((_) async => Right(tProjects));
      bloc.add(LoadProjectsEvent());
      await untilCalled(getProjects.call(any));
      verify(getProjects.call(NoParams()));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(getProjects.call(any)).thenAnswer((_) async => Right(tProjects));
      final expectedOrderedStates = [
        OnLoadedProjects(projects: tProjects)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadProjectsEvent());
    });

    test('should yield the specified ordered states when usecase returns Left(ServerFailure(X))', ()async{
      String errorMessage = 'error, pues';
      when(getProjects.call(any)).thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));
      final expectedOrderedStates = [
        OnProjectsError(message: errorMessage)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadProjectsEvent());
    });

    test('should yield the specified ordered states when usecase returns Left(Failure(X))', ()async{
      when(getProjects.call(any)).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      final expectedOrderedStates = [
        OnProjectsError(message: ProjectsBloc.GENERAL_PROJECTS_ERROR_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadProjectsEvent());
    });
  });

  group('setChosenProject', (){
    Project tProject;
    setUp((){
      tProject = _getProjectsFromFixture()[0];
    });
    
    test('should call the useCase', ()async{
      when(setChosenProject.call(any)).thenAnswer((_) async => Right(null));
      bloc.add(SetChosenProjectEvent(project: tProject));
      await untilCalled(setChosenProject.call(any));
      verify(setChosenProject.call(ChosenProjectParams(project: tProject)));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(setChosenProject.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        OnLoadingChosenProject(),
        OnLoadedChosenProject(project: tProject)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SetChosenProjectEvent(project: tProject));
    });

    test('should yield the specified ordered states when usecase returns Left(Failure(X))', ()async{
      when(setChosenProject.call(any)).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      final expectedOrderedStates = [
        OnLoadingChosenProject(),
        OnProjectsError(message: ProjectsBloc.GENERAL_CHOSEN_PROJECT_ERROR_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(SetChosenProjectEvent(project: tProject));
    });
  });

  group('loadChosenProject', (){
    Project tProject;
    setUp((){
      tProject = _getProjectsFromFixture()[0];
    });

    test('should call the usecase', ()async{
      when(getChosenProject.call(any)).thenAnswer((_) async => Right(tProject));
      bloc.add(LoadChosenProjectEvent());
      await untilCalled(getChosenProject.call(any));
      verify(getChosenProject.call(NoParams()));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(getChosenProject.call(any)).thenAnswer((_) async => Right(tProject));
      final expectedOrderedStates = [
        OnLoadingChosenProject(),
        OnLoadedChosenProject(project: tProject)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadChosenProjectEvent());
    });

    test('should yield the specified ordered states when usecase returns Left(x)', ()async{
      String errorMessage = 'mensajito';
      when(getChosenProject.call(any)).thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));
      final expectedOrderedStates = [
        OnLoadingChosenProject(),
        OnProjectsError(message: errorMessage)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadChosenProjectEvent());
    });
  });
}

List<Project> _getProjectsFromFixture(){
  String stringProjects = callFixture('projects.json');
  List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  List<Project> projects = projectsFromRemoteJson(jsonProjects);
  return projects;
}