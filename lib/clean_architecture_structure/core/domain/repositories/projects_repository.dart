import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class ProjectsRepository{
  Future<Either<Failure, List<Project>>> getProjects();
  Future<Either<Failure, void>> setChosenProject(Project project);
  Future<Either<Failure, Project>> getChosenProject();
}