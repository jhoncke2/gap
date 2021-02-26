part of 'chosen_form_bloc.dart';

enum FormStep{
  WithoutForm,
  OnForm,
  OnFirstFirmerInformation,
  OnFirstFirmerFirm,
  OnSecondaryFirms
}

@immutable
class ChosenFormState{
  final FormStep formStep;
  final List<List<OldCustomFormField>> _formFieldsPerPage;
  final List<PersonalInformation> firmers;
  
  ChosenFormState({
    this.formStep = FormStep.WithoutForm,
    List<List<OldCustomFormField>> formFieldsPerPage, 
    this.firmers
  }):
    _formFieldsPerPage = formFieldsPerPage??[]
  ;

  ChosenFormState copyWith({
    FormStep formStep,
    List<List<OldCustomFormField>> formFieldsPerPage,
    List<PersonalInformation> firmers,
  })=>ChosenFormState(
    formStep:formStep??this.formStep,
    formFieldsPerPage:formFieldsPerPage??_formFieldsPerPage,
    firmers:firmers??this.firmers
  );

  List<OldCustomFormField> getFormFieldsByIndex(int index){
    return _formFieldsPerPage[index];
  }

  List<OldCustomFormField> get allFields{
    final List<OldCustomFormField> fields = [];
    for(List<OldCustomFormField> section in _formFieldsPerPage)
      fields.addAll(section);
    return fields;
  }
}
