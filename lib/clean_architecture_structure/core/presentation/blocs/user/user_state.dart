part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserQuiet extends UserState {}
class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;

  UserError({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}
