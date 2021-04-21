import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:meta/meta.dart';

part 'keyboard_listener_event.dart';
part 'keyboard_listener_state.dart';

class KeyboardListenerBloc extends Bloc<KeyboardListenerEvent, KeyboardListenerState> {
  KeyboardListenerBloc() : super(KeyboardListenerState()){
    KeyboardVisibilityNotification().addNewListener(onChange: (bool isActive){
      add(ChangeKeyboardState(isActive: isActive));
    });
  }

  @override
  Stream<KeyboardListenerState> mapEventToState(
    KeyboardListenerEvent event,
  ) async* {
    if(event is ChangeKeyboardState)
      yield state.copyWith(isActive: event.isActive);
  }
}