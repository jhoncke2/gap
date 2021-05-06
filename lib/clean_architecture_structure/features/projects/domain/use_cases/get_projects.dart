import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class GetProjects implements UseCase<List<Project>, NoParams>{
  final ProjectsRepository repository;

  GetProjects({
    @required this.repository
  });
  
  @override
  Future<Either<Failure, List<Project>>> call(NoParams params)async{
    return await repository.getProjects();
  }
}