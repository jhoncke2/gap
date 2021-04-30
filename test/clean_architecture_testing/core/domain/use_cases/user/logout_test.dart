import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/logout.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository{}

Logout useCase;
MockUserRepository repository;

void main(){
  setUp((){
    repository = MockUserRepository();
    useCase = Logout(repository: repository);
  });

  group('logout', (){

    test('should logout successfuly and return Right(null) when all goes good', ()async{
      when(repository.logout()).thenAnswer((_) async => Right(null));
      final result = await useCase(NoParams());
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