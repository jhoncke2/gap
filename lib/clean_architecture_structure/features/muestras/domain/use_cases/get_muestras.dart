import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class GetMuestras implements UseCase<Muestra, NoParams>{
  final MuestrasRepository repository;

  GetMuestras({
    @required this.repository
  });

  @override
  Future<Either<Failure, Muestra>> call(NoParams params)async{
    return await repository.getMuestra();
  }
}