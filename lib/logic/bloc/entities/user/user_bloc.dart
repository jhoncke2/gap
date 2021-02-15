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
    // TODO: implement mapEventToState
  }
}
