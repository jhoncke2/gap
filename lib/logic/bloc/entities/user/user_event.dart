part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SetAuthToken extends UserEvent{
  final String authToken;
  SetAuthToken({
    @required this.authToken
  });
}
