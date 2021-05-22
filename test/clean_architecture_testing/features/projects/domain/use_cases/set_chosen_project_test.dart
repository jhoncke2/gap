import 'package:dartz/dartz.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/set_chosen_project.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

SetChosenProject useCase;
MockProjectsRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockProjectsRepository();
    useCase = SetChosenProject(
      repository: repository,
      errorHandler: errorHandler
    );
  });

  group('call', (){
    Project tProject;
    setUp((){
      tProject = Project(id: 0, nombre: 'pr');
    });
    
    test('should call the repository method', ()async{
      when(repository.setChosenProject(any)).thenAnswer((_) async => Right(null));
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realnvocation) => realnvocation.positionalArguments[0]());
      final result = await useCase(ChosenProjectParams(project: tProject));
      verify(errorHandler.executeFunction(any));
      verify(repository.setChosenProject(tProject));
      expect(result, Right(null));
    });
  });
}