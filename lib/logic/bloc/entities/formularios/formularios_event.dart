part of 'formularios_bloc.dart';

@immutable
abstract class FormulariosEvent {}

class SetForms extends FormulariosEvent{
  final List<OldFormulario> forms;
  SetForms({
    @required this.forms
  });
}

class ChooseForm extends FormulariosEvent{
  final OldFormulario chosenOne;
  ChooseForm({
    @required this.chosenOne
  });
}

class ResetForms extends FormulariosEvent{}
