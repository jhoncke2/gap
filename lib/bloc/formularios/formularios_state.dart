part of 'formularios_bloc.dart';

@immutable
class FormulariosState {
  final bool formsAreLoaded;
  final List<Formulario> forms;

  FormulariosState({
    this.formsAreLoaded = false,
    this.forms,
  });

  FormulariosState copyWith({
    bool formsAreLoaded,
    List<Formulario> forms
  }) => FormulariosState(
    formsAreLoaded: formsAreLoaded??this.formsAreLoaded,
    forms: forms??this.forms
  );

  FormulariosState reset() => FormulariosState();
}
