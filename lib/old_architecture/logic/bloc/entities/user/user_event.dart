part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SetAccessToken extends UserEvent{
  final String accessToken;
  SetAccessToken({
    @required this.accessToken
  });
}

class ChangeLoginButtopnAvaibleless extends UserEvent{
  final bool isAvaible;
  ChangeLoginButtopnAvaibleless({
    @required this.isAvaible
  });
}