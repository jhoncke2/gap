part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends UserEvent{
  final String email;
  final String password;

  LoginEvent({
    @required this.email, 
    @required this.password
  });

  @override
  List<Object> get props => [this.email, this.password];
}

class LogoutEvent extends UserEvent{

}
