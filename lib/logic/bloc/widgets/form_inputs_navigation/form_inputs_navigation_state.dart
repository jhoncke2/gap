part of 'form_inputs_navigation_bloc.dart';

@immutable
class FormInputsNavigationState {
  final bool thereIsSelectedForm;
  final Formulario form;
  final int pageIndex;
  final List<FormField> showedInputs;

  FormInputsNavigationState({
    this.thereIsSelectedForm = false,
    this.form, 
    this.pageIndex, 
    this.showedInputs
  });

  FormInputsNavigationState copyWith({
    bool thereIsSelectedForm,
    Formulario form,    
    int pageIndex,
    List<FormField> showedInputs,
  }) => FormInputsNavigationState(
    thereIsSelectedForm: thereIsSelectedForm??this.thereIsSelectedForm,
    form: form??this.form,
    pageIndex: pageIndex??this.pageIndex,
    showedInputs: showedInputs??this.showedInputs   
  );

  FormInputsNavigationState reset() => FormInputsNavigationState();
}
