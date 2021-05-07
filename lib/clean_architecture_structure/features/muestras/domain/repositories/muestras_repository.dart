import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';

abstract class MuestrasRepository{
  Future<Either<Failure, Muestra>> getMuestra();
  Future<Either<Failure, void>> setMuestra(Muestra muestra);
}