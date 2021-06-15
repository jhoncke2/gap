import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_chosen_project.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetChosenProject useCase;
MockProjectsRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    repository = MockProjectsRepository();
    errorHandler = MockUseCaseErrorHandler();
    useCase = GetChosenProject(
      repository: repository,
      errorHandler: errorHandler
    );
  });

  group('call', (){
    Project tProject;

    setUp((){
      tProject = Project(id: 1, nombre: 'p');
      when(errorHandler.executeFunction<Project>(any)).thenAnswer((realnvocation) => realnvocation.positionalArguments[0]());
    });

    test('should call the repository get method', ()async{
      when(repository.getChosenProject()).thenAnswer((_) async => Right(tProject)); 
      await useCase(NoParams());
      verify(errorHandler.executeFunction<Project>(any));
      verify(repository.getChosenProject());
    });

    test('should return Right(x) when repository returns it', ()async{
      when(repository.getChosenProject()).thenAnswer((_) async => Right(tProject));
      final result = await useCase(NoParams());
      expect(result, Right(tProject));
    });

    test('should return Left(y) when repository returns it', ()async{
      when(repository.getChosenProject()).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final result = await useCase(NoParams());
      expect(result, Left(ServerFailure(message: 'mensajito')));
    });
  });

}