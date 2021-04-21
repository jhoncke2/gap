part of 'keyboard_listener_bloc.dart';

@immutable
abstract class KeyboardListenerEvent {}

class ChangeKeyboardState extends KeyboardListenerEvent{
  final bool isActive;
  ChangeKeyboardState({
    @required this.isActive
  });
}
