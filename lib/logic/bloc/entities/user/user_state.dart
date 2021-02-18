part of 'user_bloc.dart';

@immutable
class UserState {
  final bool authTokenIsLoaded;
  final String authToken;

  UserState({
    this.authTokenIsLoaded = false,
    this.authToken
  });

  UserState copyWith({
    bool authTokenIsLoaded,
    String authToken
  })=>UserState(
    authTokenIsLoaded: authTokenIsLoaded??this.authTokenIsLoaded,
    authToken: authToken??this.authToken
  );
}
