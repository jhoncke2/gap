import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/index.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class IndexRepository{
  Future<Either<Failure, void>> setIndex(Index index);
  Future<Either<Failure, Index>> getIndex();
}