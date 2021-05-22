import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import '../use_case.dart';

class Login implements UseCase<void, LoginParams>{
  final UserRepository userRepository;
  final CentralSystemRepository centralSystemRepository;
  final UseCaseErrorHandler errorHandler;
  Login({
    @required this.userRepository,
    @required this.centralSystemRepository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(LoginParams params)async{
    return await errorHandler.executeFunction<void>(() async{
      await centralSystemRepository.setAppRunnedAnyTime();
      return await userRepository.login(params.user);
    });
    
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