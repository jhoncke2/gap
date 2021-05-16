import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';

class SetChosenProject implements UseCase<void, ChosenProjectParams>{
  final ProjectsRepository repository;

  SetChosenProject({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(ChosenProjectParams params) async {
    return await repository.setChosenProject(params.project);
  }
}

class ChosenProjectParams extends Equatable{
  final Project project;

  ChosenProjectParams({
    @required this.project
  });

  @override
  List<Object> get props => [this.project];
}