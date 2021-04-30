part of 'user_bloc.dart';

@immutable
class UserOldState {
  final bool authTokenIsLoaded;
  final String authToken;
  final bool loginButtonIsAvaible;

  UserOldState({
    this.authTokenIsLoaded = false,
    this.authToken,
    this.loginButtonIsAvaible = true
  });

  UserOldState copyWith({
    bool authTokenIsLoaded,
    String authToken,
    bool loginButtonIsAvaible
  })=>UserOldState(
    authTokenIsLoaded: authTokenIsLoaded??this.authTokenIsLoaded,
    authToken: authToken??this.authToken,
    loginButtonIsAvaible: loginButtonIsAvaible??this.loginButtonIsAvaible
  );
}
