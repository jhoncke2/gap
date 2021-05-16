import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SetMuestra implements UseCase<void, SetMuestraParams>{
  final MuestrasRepository repository;

  SetMuestra({
    @required this.repository
  });
  @override
  Future<Either<Failure, void>> call(SetMuestraParams params)async{
    return await repository.setMuestra(params.selectedRangoIndex, params.pesosTomados);
  }
}

class SetMuestraParams extends Equatable{
  final int selectedRangoIndex;
  final List<double> pesosTomados;

  SetMuestraParams({
    @required this.selectedRangoIndex,
    @required this.pesosTomados
  });

  @override
  List<Object> get props => [this.selectedRangoIndex, pesosTomados];
}