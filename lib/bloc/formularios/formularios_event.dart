part of 'formularios_bloc.dart';

@immutable
abstract class FormulariosEvent {}

class SetForms extends FormulariosEvent{
  final List<Formulario> forms;
  SetForms({
    @required this.forms
  });
}

class ResetForms extends FormulariosEvent{}
