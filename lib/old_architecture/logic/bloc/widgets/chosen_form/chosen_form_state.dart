part of 'chosen_form_bloc.dart';

enum FormStep{
  WithoutForm,
  OnFormFillingOut,
  OnFormReading,
  OnFirstFirmerInformation,
  OnFirstFirmerFirm,
  OnSecondaryFirms,
  Finished
}

@immutable
class ChosenFormState{
  final bool formIsLocked;
  final FormStep formStep;
  final List<List<CustomFormFieldOld>> _formFieldsPerPage;
  final List<PersonalInformationOld> firmers;
  
  ChosenFormState({
    this.formIsLocked = false,
    this.formStep = FormStep.WithoutForm,
    List<List<CustomFormFieldOld>> formFieldsPerPage, 
    this.firmers
  }):
    _formFieldsPerPage = formFieldsPerPage??[]
  ;

  ChosenFormState copyWith({
    bool formIsLocked,
    FormStep formStep,
    List<List<CustomFormFieldOld>> formFieldsPerPage,
    List<PersonalInformationOld> firmers,
  })=>ChosenFormState(
    formIsLocked: formIsLocked??this.formIsLocked,
    formStep:formStep??this.formStep,
    formFieldsPerPage:formFieldsPerPage??_formFieldsPerPage,
    firmers:firmers??this.firmers
  );

  List<CustomFormFieldOld> getFormFieldsByIndex(int index){
    return _formFieldsPerPage.length > index? _formFieldsPerPage[index]:[];
  }

  List<CustomFormFieldOld> get allFields{
    final List<CustomFormFieldOld> fields = [];
    for(List<CustomFormFieldOld> section in _formFieldsPerPage)
      fields.addAll(section);
    return fields;
  }
}
