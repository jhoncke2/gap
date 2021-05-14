import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_chosen_project.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository {}

GetChosenProject useCase;
MockProjectsRepository repository;

void main(){
  setUp((){
    repository = MockProjectsRepository();
    useCase = GetChosenProject(
      repository: repository
    );
  });

  group('call', (){
    Project tProject;

    setUp((){
      tProject = Project(id: 1, nombre: 'p');
    });

    test('should call the repository get method', ()async{
      when(repository.getChosenProject()).thenAnswer((_) async => Right(tProject));
      await useCase(NoParams());
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