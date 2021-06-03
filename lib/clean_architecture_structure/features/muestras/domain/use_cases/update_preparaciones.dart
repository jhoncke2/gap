import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class UpdatePreparaciones implements UseCase<void, UpdatePreparacionesParams>{

  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;
  UpdatePreparaciones({
    @required this.repository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(UpdatePreparacionesParams params)async{
    return await errorHandler.executeFunction<void>(
      () => repository.updatePreparaciones(params.muestreoId, params.preparaciones)
    );
  }
}

class UpdatePreparacionesParams extends Equatable{
  final int muestreoId;
  final List<String> preparaciones;

  UpdatePreparacionesParams({
    @required this.muestreoId,
    @required this.preparaciones
  });

  @override
  List<Object> get props => [this.preparaciones];
}