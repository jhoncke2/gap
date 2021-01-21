part of 'form_inputs_navigation_bloc.dart';

@immutable
abstract class FormInputsNavigationEvent {}

class SetForm extends FormInputsNavigationEvent{
  final Formulario form;
  SetForm({
    @required this.form
  });
}

class ChangePageIndex extends FormInputsNavigationEvent{
  final int newIndex;
  ChangePageIndex({
    @required this.newIndex
  });
}

class ResetAll extends FormInputsNavigationEvent{}
