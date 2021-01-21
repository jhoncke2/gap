part of 'form_inputs_navigation_bloc.dart';

@immutable
abstract class FormInputNavigationEvent {}

class SetForm extends FormInputNavigationEvent{
  final Formulario form;
  SetForm({
    @required this.form
  });
}

class ChangePageIndex extends FormInputNavigationEvent{
  final int newIndex;
  ChangePageIndex({
    @required this.newIndex
  });
}

class ResetAll extends FormInputNavigationEvent{}
