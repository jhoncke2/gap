import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class UserRepository{
  Future<Either<Failure, void>> login(User user);
  Future<Either<Failure, void>> reLogin();
  Future<Either<Failure, void>> refreshAccessToken();
  Future<Either<Failure, void>> logout();
}