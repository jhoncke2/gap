import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class EndMuestreo implements UseCase<void, NoParams>{
  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;
  EndMuestreo({
    @required this.repository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(NoParams params)async{
    return await errorHandler.executeFunction<void>(
      () => repository.endMuestreo()
    );
  }
}