import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';

abstract class UseCaseErrorHandler{
  Future<Either<Failure, B>> executeFunction<B>(Future<Either<Failure, B>> Function() function);
}

class UseCaseErrorHandlerImpl implements UseCaseErrorHandler{
  final CentralSystemRepository centralSystemRepository;
  final UserRepository userRepository;

  UseCaseErrorHandlerImpl({
    @required this.centralSystemRepository, 
    @required this.userRepository
  });

  @override
  Future<Either<Failure, B>> executeFunction<B>(Future<Either<Failure, B>> Function() function)async{
    final eitherFunction = await function();
    return await eitherFunction.fold((failure)async{
      if(failure is StorageFailure){
        if(failure.type == StorageFailureType.PLATFORM){
          await centralSystemRepository.removeAll();
          await centralSystemRepository.setAppRunnedAnyTime();
          return await function();
        }
      }else if(failure is ServerFailure){
        if(failure.type == ServerFailureType.UNHAUTORAIZED){
          await userRepository.reLogin();
          return await function();
        }
      }
      return Left(failure);
    }, (returnedValue)async{
      return Right(returnedValue);
    });
  }

}