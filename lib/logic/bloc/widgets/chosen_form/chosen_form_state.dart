part of 'chosen_form_bloc.dart';

enum FormStep{
  WithoutForm,
  OnForm,
  OnFirstFirmerInformation,
  OnFirstFirmerFirm,
  OnSecondaryFirms
}

@immutable
class ChosenFormState {
  final FormStep formStep;
  final List<List<FormField>> _formFieldsPerPage;
  final List<PersonalInformation> firmers;
  
  ChosenFormState({
    this.formStep = FormStep.WithoutForm,
    List<List<FormField>> formFieldsPerPage, 
    this.firmers
  }):
    _formFieldsPerPage = formFieldsPerPage??[]
  ;

  ChosenFormState copyWith({
    FormStep formStep,
    List<List<FormField>> formFieldsPerPage,
    List<PersonalInformation> firmers,
  })=>ChosenFormState(
    formStep:formStep??this.formStep,
    formFieldsPerPage:formFieldsPerPage??_formFieldsPerPage,
    firmers:firmers??this.firmers
  );

  List<FormField> getFormFieldsByIndex(int index){
    return _formFieldsPerPage[index];
  }
}
