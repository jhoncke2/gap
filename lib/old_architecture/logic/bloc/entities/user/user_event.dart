part of 'user_bloc.dart';

@immutable
abstract class UserOldEvent {}

class SetAccessToken extends UserOldEvent{
  final String accessToken;
  SetAccessToken({
    @required this.accessToken
  });
}

class ChangeLoginButtopnAvaibleless extends UserOldEvent{
  final bool isAvaible;
  ChangeLoginButtopnAvaibleless({
    @required this.isAvaible
  });
}