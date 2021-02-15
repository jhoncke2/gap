part of 'user_bloc.dart';

@immutable
class UserState {
  final String authToken;

  UserState({this.authToken});

  UserState copyWith({
    String authToken
  })=>UserState(
    authToken: authToken??this.authToken
  );
}
