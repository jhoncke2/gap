import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class CentralSystemRepository{
  Future<Either<Failure, void>> removeAll();
  Future<Either<Failure, bool>> getAppRunnedAnyTime();
  Future<Either<Failure, void>> setAppRunnedAnyTime();
}