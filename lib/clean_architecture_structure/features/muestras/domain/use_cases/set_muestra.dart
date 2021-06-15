import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SetMuestra implements UseCase<void, SetMuestraParams>{
  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;
  SetMuestra({
    @required this.repository,
    @required this.errorHandler
  });
  @override
  Future<Either<Failure, void>> call(SetMuestraParams params)async{
    return await errorHandler.executeFunction<void>(
      () => repository.setMuestra(params.muestreoId, params.selectedRangoId, params.pesosTomados)
    );
  }
}

class SetMuestraParams extends Equatable{
  final int muestreoId;
  final int selectedRangoId;
  final List<double> pesosTomados;

  SetMuestraParams({
    @required this.muestreoId,
    @required this.selectedRangoId,
    @required this.pesosTomados
  });

  @override
  List<Object> get props => [this.muestreoId, this.selectedRangoId, this.pesosTomados];
}