import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class GetMuestras implements UseCase<Muestreo, NoParams>{
  final MuestrasRepository repository;

  GetMuestras({
    @required this.repository
  });

  @override
  Future<Either<Failure, Muestreo>> call(NoParams params)async{
    return await repository.getMuestreo();
  }
}