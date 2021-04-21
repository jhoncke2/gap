part of 'formularios_bloc.dart';

@immutable
abstract class FormulariosEvent {}

class SetForms extends FormulariosEvent{
  final List<FormularioOld> forms;
  SetForms({
    @required this.forms
  });
}

class ChooseForm extends FormulariosEvent{
  final FormularioOld chosenOne;
  ChooseForm({
    @required this.chosenOne
  });
}

class ChangeFormsAreBlocked extends FormulariosEvent{
  final bool areBlocked;
  ChangeFormsAreBlocked({
    @required this.areBlocked
  });
}

class ResetForms extends FormulariosEvent{}
