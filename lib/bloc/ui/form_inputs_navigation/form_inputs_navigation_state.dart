part of 'form_inputs_navigation_bloc.dart';

@immutable
class FormInputNavigationState {
  final Formulario form;
  final int pageIndex;
  final List<FormInput> showedInputs;

  FormInputNavigationState({
    this.form, 
    this.pageIndex, 
    this.showedInputs
  });

  FormInputNavigationState copyWith({
    Formulario form,    
    int pageIndex,
    List<FormInput> showedInputs,
  }) => FormInputNavigationState(
    form: form??this.form,
    pageIndex: pageIndex??this.pageIndex,
    showedInputs: showedInputs??this.showedInputs   
  );

  FormInputNavigationState reset() => FormInputNavigationState();
}
