import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository{}

Login useCase;
MockUserRepository repository;

void main(){
  setUp((){
    repository = MockUserRepository();
    useCase = Login(userRepository: repository);
  });

  group('login', (){
    User tUser;

    setUp((){
      tUser = User(email: 'email', password: 'password');
    });
    test('should return Right(null) when all goes good', ()async{
      when(repository.login(any)).thenAnswer((_) async => Right(null));
      final result = await useCase(LoginParams(user: tUser));
      verify(repository.login(tUser));
      expect(result, Right(null));
      verifyNoMoreInteractions(repository);
    });
  });
}