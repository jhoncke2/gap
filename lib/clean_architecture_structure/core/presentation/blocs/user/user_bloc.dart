import 'dart:async';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/presentation/utils/input_validator.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/login.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/user/logout.dart';

part 'user_event.dart';
part 'user_state.dart';

const BAD_EMAIL_MESSAGE = 'El email está vacío';
const BAD_PASSWORD_MESSAGE = 'El password está vacío';
const GENERAL_ERROR_MESSAGE = 'Ocurrió un error';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Login login;
  final Logout logout;
  final InputValidator inputValidator;

  UserBloc({
    @required this.login,
    @required this.logout,
    @required this.inputValidator
  }) :
    assert(login != null),
    assert(logout != null),
    super(UserQuiet());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if(event is LoginEvent){
      yield UserLoading();
      final eitherValidatedEmail = inputValidator.validateInputValue(event.email);
      yield * eitherValidatedEmail.fold((_)async*{
        yield UserError(message: BAD_EMAIL_MESSAGE); 
      }, (_)async*{
        yield * _loginUntilPasswordValidation(event);
      });
    }else if(event is LogoutEvent){
      yield UserLoading();
      final eitherLogout = await logout(NoParams());
      yield * eitherLogout.fold((_)async*{
        yield UserError(message: GENERAL_ERROR_MESSAGE);
      }, (_)async*{
        yield UserQuiet();
      });
    }
  }

  Stream<UserState> _loginUntilPasswordValidation(LoginEvent event)async*{
    final eitherValidaterPassword = inputValidator.validateInputValue(event.password);
    yield * eitherValidaterPassword.fold((_)async*{
      yield UserError(message: BAD_PASSWORD_MESSAGE);
    }, (_)async*{
      yield * _loginUntilUseCase(event);
    });
  }

  Stream<UserState> _loginUntilUseCase(LoginEvent event)async*{
    final User user = User(email: event.email, password: event.password);
    final eitherLogin = await login(LoginParams(user: user));
    yield * eitherLogin.fold((failure)async*{
      String message;
      if(failure is ServerFailure)
        message = failure.message;
      else
        message = GENERAL_ERROR_MESSAGE;
      yield UserError(message: message);
    }, (r)async*{
    });
  }
}
