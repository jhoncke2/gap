import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../use_case.dart';

class Login implements UseCase<void, LoginParams>{
  final UserRepository repository;

  Login({
    @required this.repository
  });

  @override
  Future<Either<Failure, void>> call(LoginParams params)async{
    return await repository.login(params.user);
  }
}

class LoginParams extends Equatable{
  final User user;

  LoginParams({
    @required this.user
  });

  @override
  List<Object> get props => [this.user];
}