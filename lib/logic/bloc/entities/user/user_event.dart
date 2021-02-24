part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SetAuthToken extends UserEvent{
  final String authToken;
  SetAuthToken({
    @required this.authToken
  });
}

class ChangeLoginButtopnAvaibleless extends UserEvent{
  final bool isAvaible;
  ChangeLoginButtopnAvaibleless({
    @required this.isAvaible
  });
}