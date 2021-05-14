import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/set_chosen_project.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockProjectsRepository extends Mock implements ProjectsRepository{}

SetChosenProject useCase;
MockProjectsRepository repository;

void main(){
  setUp((){
    repository = MockProjectsRepository();
    useCase = SetChosenProject(repository: repository);
  });

  group('call', (){
    Project tProject;
    setUp((){
      tProject = Project(id: 0, nombre: 'pr');
    });
    
    test('should call the repository method', ()async{
      await useCase(ChosenProjectParams(project: tProject));
      verify(repository.setChosenProject(tProject));
    });
  });
}