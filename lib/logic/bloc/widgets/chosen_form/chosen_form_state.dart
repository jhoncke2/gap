part of 'chosen_form_bloc.dart';

enum FormStep{
  WithoutForm,
  OnForm,
  OnFirstFirmerInformation,
  OnFirms
}

@immutable
class ChosenFormState {
  final FormStep formStep;
  final List<List<FormField>> formFieldsPerPage;
  final List<PersonalInformation> firmers;
  
  ChosenFormState({
    this.formStep = FormStep.WithoutForm,
    this.formFieldsPerPage, 
    this.firmers
  });

  ChosenFormState copyWith({
    FormStep formStep,
    List<List<FormField>> formFieldsPerPage,
    List<PersonalInformation> firmers,
  })=>ChosenFormState(
    formStep:formStep??this.formStep,
    formFieldsPerPage:formFieldsPerPage??this.formFieldsPerPage,
    firmers:firmers??this.firmers
  );
}
