import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

import '../use_case_error_handler.dart';

class Logout extends UseCase<void, NoParams>{
  final UserRepository repository;
  final UseCaseErrorHandler errorHandler;

  Logout({
    @required this.repository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(NoParams params)async{
    return await errorHandler.executeFunction(() => repository.logout());
  }

}