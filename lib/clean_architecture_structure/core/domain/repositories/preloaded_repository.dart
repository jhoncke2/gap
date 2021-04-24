import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class PreloadedRepository{
  Future<Either<Failure, void>> sendPreloadedData();
}