import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class SetChosenVisit implements UseCase<void, ChosenVisitParams>{
  final VisitsRepository repository;
  final UseCaseErrorHandler errorHandler;

  SetChosenVisit({
    @required this.repository, 
    @required this.errorHandler
  });
  @override
  Future<Either<Failure, void>> call(ChosenVisitParams params)async{
    return await errorHandler.executeFunction(() => repository.setChosenVisit(params.chosenVisit));
  }
}

class ChosenVisitParams extends Equatable{
  final Visit chosenVisit;
  ChosenVisitParams({
    @required this.chosenVisit
  });

  @override
  List<Object> get props => [this.chosenVisit];
}