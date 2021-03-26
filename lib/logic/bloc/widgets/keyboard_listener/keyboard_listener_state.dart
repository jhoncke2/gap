part of 'keyboard_listener_bloc.dart';

@immutable
class KeyboardListenerState {
  final bool isActive;
  KeyboardListenerState({
    this.isActive = false
  });
  
  KeyboardListenerState copyWith({
    bool isActive
  })=>KeyboardListenerState(
    isActive: isActive??this.isActive
  );
}