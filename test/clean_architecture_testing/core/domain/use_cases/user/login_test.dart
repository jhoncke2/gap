import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository{}
class MockCentralSystemRepository extends Mock implements CentralSystemRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

Login useCase;
MockUserRepository userRepository;
MockCentralSystemRepository centralSystemRepository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){ 
    centralSystemRepository = MockCentralSystemRepository();
    userRepository = MockUserRepository();
    errorHandler = MockUseCaseErrorHandler();
    useCase = Login(
      userRepository: userRepository,
      centralSystemRepository: centralSystemRepository,
      errorHandler: errorHandler
    );
  });

  group('login', (){
    User tUser;
    setUp((){
      tUser = User(email: 'email', password: 'password');
    });
    test('should return Right(null) when all goes good', ()async{
      when(userRepository.login(any)).thenAnswer((_) async => Right(null));
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realnvocation) => realnvocation.positionalArguments[0]());
      final result = await useCase(LoginParams(user: tUser));
      verify(errorHandler.executeFunction<void>(any));
      verify(centralSystemRepository.setAppRunnedAnyTime());
      verify(userRepository.login(tUser));
      expect(result, Right(null));
      verifyNoMoreInteractions(userRepository);
    });
  });
}