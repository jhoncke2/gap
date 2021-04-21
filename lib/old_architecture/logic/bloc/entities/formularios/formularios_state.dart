part of 'formularios_bloc.dart';

@immutable
class FormulariosState{
//TODO: Averiguar diferencia entre formsAreLoaded y formsAreBlocked (¿para qué se usa cada uno?)
  final bool formsAreLoaded;
  final List<FormularioOld> forms;
  final List<FormularioOld> pendientesForms;
  final List<FormularioOld> realizadosForms;
  final FormularioOld chosenForm;
  final bool backing;
  final bool formsAreBlocked;

  FormulariosState({
    this.formsAreLoaded = false,
    this.forms,
    this.pendientesForms,
    this.realizadosForms,
    this.chosenForm,
    this.backing = true,
    this.formsAreBlocked = true
  });

  FormulariosState copyWith({
    bool formsAreLoaded,
    List<FormularioOld> forms,
    List<FormularioOld> pendientesForms,
    List<FormularioOld> realizadosForms,
    FormularioOld chosenForm,
    bool backing,
    bool formsAreBlocked
  }) => FormulariosState(
    formsAreLoaded: formsAreLoaded??this.formsAreLoaded,
    forms: forms??this.forms,
    pendientesForms: pendientesForms??this.pendientesForms,
    realizadosForms: realizadosForms??this.realizadosForms,
    chosenForm: chosenForm??this.chosenForm,
    backing: backing??this.backing,
    formsAreBlocked: formsAreBlocked??this.formsAreBlocked
  );

  FormulariosState reset() => FormulariosState();
}