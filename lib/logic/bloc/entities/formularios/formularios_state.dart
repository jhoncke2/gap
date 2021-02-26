part of 'formularios_bloc.dart';


@immutable
class FormulariosState{
  final bool formsAreLoaded;
  final List<OldFormulario> forms;
  final List<OldFormulario> pendientesForms;
  final List<OldFormulario> realizadosForms;
  final OldFormulario chosenForm;

  FormulariosState({
    this.formsAreLoaded = false,
    this.forms,
    this.pendientesForms,
    this.realizadosForms,
    this.chosenForm    
  });

  FormulariosState copyWith({
    bool formsAreLoaded,
    List<OldFormulario> forms,
    List<OldFormulario> pendientesForms,
    List<OldFormulario> realizadosForms,
    OldFormulario chosenForm    
  }) => FormulariosState(
    formsAreLoaded: formsAreLoaded??this.formsAreLoaded,
    forms: forms??this.forms,
    pendientesForms: pendientesForms??this.pendientesForms,
    realizadosForms: realizadosForms??this.realizadosForms,
    chosenForm: chosenForm??this.chosenForm    
  );

  FormulariosState reset() => FormulariosState();
}