import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

abstract class NavigationRepository{
  Future<Either<Failure, void>> setNavRoute(NavigationRoute navRoute);
  Future<Either<Failure, void>> replaceAllNavRoutesForNew(NavigationRoute navRoute);
  Future<Either<Failure, void>> pop();
  Future<Either<Failure, NavigationRoute>> getCurrentRoute();
}