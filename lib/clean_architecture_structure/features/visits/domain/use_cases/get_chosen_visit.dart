import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class GetChosenVisit implements UseCase<Visit, NoParams>{
  final VisitsRepository repository;
  final UseCaseErrorHandler errorHandler;

  GetChosenVisit({
    @required this.repository, 
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, Visit>> call(NoParams params)async{
    return await errorHandler.executeFunction(() => repository.getChosenVisit());
  }

}