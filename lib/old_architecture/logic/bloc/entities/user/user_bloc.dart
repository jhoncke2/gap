import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserOldBloc extends Bloc<UserOldEvent, UserOldState> {
  UserOldBloc() : super(UserOldState());

  @override
  Stream<UserOldState> mapEventToState(
    UserOldEvent event,
  ) async* {
    if(event is SetAccessToken){
      yield state.copyWith(authTokenIsLoaded: true, authToken: event.accessToken);
    }else if(event is ChangeLoginButtopnAvaibleless){
      yield state.copyWith(loginButtonIsAvaible: event.isAvaible);
    }
  }
}
