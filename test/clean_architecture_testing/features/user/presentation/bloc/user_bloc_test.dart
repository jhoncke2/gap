import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/logout.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/input_validator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockLogin extends Mock implements Login{}
class MockLogout extends Mock implements Logout{}
class MockInputValidator extends Mock implements InputValidator{}

UserBloc bloc;
MockLogin loginUseCase;
MockLogout logoutUseCase;
MockInputValidator inputValidator;
void main(){
  setUp((){
    logoutUseCase = MockLogout();
    loginUseCase = MockLogin();
    inputValidator = MockInputValidator();
    bloc = UserBloc(
      login: loginUseCase, 
      logout: logoutUseCase,
      inputValidator: inputValidator
    );
  });

  test('initial state should be Quiet', ()async{
    expect(bloc.state, equals(UserQuiet()));
  });

  group('login', (){
    User tUser;
    setUp((){
      tUser = User(email: 'email', password: 'password');
    });

    test('should call the inputValidator to validate the email and the password', ()async{
      when(inputValidator.validateInputValue(any)).thenReturn(Right(null));
      when(loginUseCase.call(any)).thenAnswer((_) async => Right(null));
      bloc.add(LoginEvent(email: tUser.email, password: tUser.password));
      await untilCalled(inputValidator.validateInputValue(any));
      verify(inputValidator.validateInputValue(tUser.email));
      //await untilCalled(inputValidator.validateInputValue(any));
      //verify(inputValidator.validateInputValue(any));
    });

    test('should emmit the specified states in order when email is empty or null', ()async{
      when(inputValidator.validateInputValue(tUser.email)).thenReturn(Left(InvalidInputFailure()));
      when(inputValidator.validateInputValue(tUser.password)).thenReturn(Right(null));
      when(loginUseCase.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        UserLoading(),
        UserError(message: BAD_EMAIL_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoginEvent(email: tUser.email, password: tUser.password));
    });

    test('should emmit the specified states in order when password is empty or null', ()async{
      when(inputValidator.validateInputValue(tUser.email)).thenReturn(Right(null));
      when(inputValidator.validateInputValue(tUser.password)).thenReturn(Left(InvalidInputFailure()));
      when(loginUseCase.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        UserLoading(),
        UserError(message: BAD_PASSWORD_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoginEvent(email: tUser.email, password: tUser.password));
    });

    test('should emmit the specified states in order when input values are fine but loginUseCase return Left(X)', ()async{
      when(inputValidator.validateInputValue(tUser.email)).thenReturn(Right(null));
      when(inputValidator.validateInputValue(tUser.password)).thenReturn(Right(null));
      when(loginUseCase.call(any)).thenAnswer((_) async => Left(ServerFailure(
        servExcType: ServerExceptionType.LOGIN, 
        message: 'Credenciales inválidas')
      ));
      final expectedOrderedStates = [
        UserLoading(),
        UserError(message: 'Credenciales inválidas')
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoginEvent(email: tUser.email, password: tUser.password));
      await untilCalled(loginUseCase(any));
      verify(loginUseCase(LoginParams(user: tUser)));
    });

    test('should emmit the specified states in order when all goes good', ()async{
      when(inputValidator.validateInputValue(tUser.email)).thenReturn(Right(null));
      when(inputValidator.validateInputValue(tUser.password)).thenReturn(Right(null));
      when(loginUseCase.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        UserLoading()
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoginEvent(email: tUser.email, password: tUser.password));
    });
  });
}