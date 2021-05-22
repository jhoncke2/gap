import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/logout.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

Logout useCase;
MockUserRepository repository;
MockUseCaseErrorHandler errorHandler;
void main(){
  setUp((){
    repository = MockUserRepository();
    errorHandler = MockUseCaseErrorHandler();
    useCase = Logout(
      repository: repository,
      errorHandler: errorHandler
    );
    
  });

  group('logout', (){

    setUp((){
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realnvocation) => realnvocation.positionalArguments[0]());
    });

    test('should logout successfuly and return Right(null) when all goes good', ()async{ 
      when(repository.logout()).thenAnswer((_) async => Right(null));
      final result = await useCase(NoParams());
      verify(errorHandler.executeFunction<void>(any));
      verify(repository.logout());
      expect(result, Right(null));
    });

    test('should return Left(X) when repository return Left(X)', ()async{
      when(repository.logout()).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      final result = await useCase(NoParams());
      verify(repository.logout());
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
  
}