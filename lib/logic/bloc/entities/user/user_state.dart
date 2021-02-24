part of 'user_bloc.dart';

@immutable
class UserState {
  final bool authTokenIsLoaded;
  final String authToken;
  final bool loginButtonIsAvaible;

  UserState({
    this.authTokenIsLoaded = false,
    this.authToken,
    this.loginButtonIsAvaible = true
  });

  UserState copyWith({
    bool authTokenIsLoaded,
    String authToken,
    bool loginButtonIsAvaible
  })=>UserState(
    authTokenIsLoaded: authTokenIsLoaded??this.authTokenIsLoaded,
    authToken: authToken??this.authToken,
    loginButtonIsAvaible: loginButtonIsAvaible??this.loginButtonIsAvaible
  );
}
