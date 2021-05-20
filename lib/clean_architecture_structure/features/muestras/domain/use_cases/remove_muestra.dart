import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class RemoveMuestra implements UseCase<void, RemoveMuestraParams>{

  final MuestrasRepository repository;

  RemoveMuestra({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(RemoveMuestraParams params){
    return repository.removeMuestra(params.muestraId);
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