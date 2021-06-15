import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class RemoveMuestra implements UseCase<void, RemoveMuestraParams>{

  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;

  RemoveMuestra({
    @required this.repository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(RemoveMuestraParams params)async{
    return await errorHandler.executeFunction<void>(() => repository.removeMuestra(params.muestraId));
  }
}

class RemoveMuestraParams extends Equatable{
  final int muestraId;

  RemoveMuestraParams({
    @required this.muestraId
  });

  @override
  List<Object> get props => [this.muestraId];
}