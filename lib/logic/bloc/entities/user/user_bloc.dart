import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if(event is SetAuthToken){
      yield state.copyWith(authTokenIsLoaded: true, authToken: event.authToken);
    }else if(event is ChangeLoginButtopnAvaibleless){
      yield state.copyWith(loginButtonIsAvaible: event.isAvaible);
    }
  }
}
