import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class UpdateMuestra implements UseCase<void, UpdateMuestraParams>{

  final MuestrasRepository repository;

  UpdateMuestra({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(UpdateMuestraParams params)async{
    return await repository.updateMuestra(params.muestraIndexEnMuestreo, params.pesosTomados);
  }
}

class UpdateMuestraParams extends Equatable{
  final int muestraIndexEnMuestreo;
  final List<double> pesosTomados;

  UpdateMuestraParams({
    @required this.muestraIndexEnMuestreo,
    @required this.pesosTomados
  });

  @override
  List<Object> get props => [this.muestraIndexEnMuestreo, pesosTomados];
}