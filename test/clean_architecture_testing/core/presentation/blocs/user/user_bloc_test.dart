import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/logout.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/input_validator.dart';

class MockLogin extends Mock implements Login{}
class MockLogout extends Mock implements Logout{}
class MockInputValidator extends Mock implements InputValidator{}
class MockNavigationRepository extends Mock implements NavigationRepository{}
class MockGoReplacingAllTo extends Mock implements GoReplacingAllTo{}

UserBloc bloc;
MockLogin loginUseCase;
MockLogout logoutUseCase;
MockInputValidator inputValidator;
MockGoReplacingAllTo navigationUseCase;
void main(){
  setUp((){
    logoutUseCase = MockLogout();
    loginUseCase = MockLogin();
    inputValidator = MockInputValidator();
    navigationUseCase = MockGoReplacingAllTo();
    bloc = UserBloc(
      login: loginUseCase, 
      logout: logoutUseCase,
      inputValidator: inputValidator,
      navigationUseCase: navigationUseCase
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
      //verify(inputValidator.validateInputValue(tUser.password));
      await untilCalled(navigationUseCase.call(any));
      verify(navigationUseCase.call(NavigationParams(navRoute: NavigationRoute.Projects)));
    });

    test('should emmit the specified states in order when email is empty or null', ()async{
      when(inputValidator.validateInputValue(tUser.email)).thenReturn(Left(InvalidInputFailure()));
      when(inputValidator.validateInputValue(tUser.password)).thenReturn(Right(null));
      when(loginUseCase.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        UserLoading(),
        UserError(message: BAD_EMAIL_MESSAGE),
        UserQuiet()
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
        UserError(message: BAD_PASSWORD_MESSAGE),
        UserQuiet()
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
        UserError(message: 'Credenciales inválidas'),
        UserQuiet()
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

  group('logout', (){
    test('should call the logout usecase', ()async{
      when(logoutUseCase.call(any)).thenAnswer((_) async => Right(null));
      bloc.add(LogoutEvent());
      await untilCalled(logoutUseCase.call(any));
      verify(logoutUseCase.call(NoParams()));
      await untilCalled(navigationUseCase.call(any));
      verify(navigationUseCase.call(NavigationParams(navRoute: NavigationRoute.Login)));
    });

    test('should yield the specified ordered states when the logoutUseCase return Left(X)', ()async{
      when(logoutUseCase.call(any)).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
      final expectedOrderedStates = [
        UserLoading(),
        UserError(message: GENERAL_ERROR_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LogoutEvent());
    });

    test('should yield the specified ordered states when all goes good)', ()async{
      when(logoutUseCase.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        UserLoading(),
        UserQuiet()
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LogoutEvent());
    });
  });
}