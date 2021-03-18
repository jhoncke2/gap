part of 'formularios_bloc.dart';

@immutable
class FormulariosState{
  final bool formsAreLoaded;
  final List<Formulario> forms;
  final List<Formulario> pendientesForms;
  final List<Formulario> realizadosForms;
  final Formulario chosenForm;
  final bool backing;

  FormulariosState({
    this.formsAreLoaded = false,
    this.forms,
    this.pendientesForms,
    this.realizadosForms,
    this.chosenForm,
    this.backing = true
  });

  FormulariosState copyWith({
    bool formsAreLoaded,
    List<Formulario> forms,
    List<Formulario> pendientesForms,
    List<Formulario> realizadosForms,
    Formulario chosenForm,
    bool backing
  }) => FormulariosState(
    formsAreLoaded: formsAreLoaded??this.formsAreLoaded,
    forms: forms??this.forms,
    pendientesForms: pendientesForms??this.pendientesForms,
    realizadosForms: realizadosForms??this.realizadosForms,
    chosenForm: chosenForm??this.chosenForm,
    backing: backing??this.backing
  );

  FormulariosState reset() => FormulariosState();
}