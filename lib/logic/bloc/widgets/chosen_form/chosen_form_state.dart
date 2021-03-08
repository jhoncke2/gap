part of 'chosen_form_bloc.dart';

enum FormStep{
  WithoutForm,
  OnForm,
  OnFirstFirmerInformation,
  OnFirstFirmerFirm,
  OnSecondaryFirms,
  Finished
}

@immutable
class ChosenFormState{
  final FormStep formStep;
  final List<List<CustomFormField>> _formFieldsPerPage;
  final List<PersonalInformation> firmers;
  
  ChosenFormState({
    this.formStep = FormStep.WithoutForm,
    List<List<CustomFormField>> formFieldsPerPage, 
    this.firmers
  }):
    _formFieldsPerPage = formFieldsPerPage??[]
  ;

  ChosenFormState copyWith({
    FormStep formStep,
    List<List<CustomFormField>> formFieldsPerPage,
    List<PersonalInformation> firmers,
  })=>ChosenFormState(
    formStep:formStep??this.formStep,
    formFieldsPerPage:formFieldsPerPage??_formFieldsPerPage,
    firmers:firmers??this.firmers
  );

  List<CustomFormField> getFormFieldsByIndex(int index){
    return _formFieldsPerPage.length > index? _formFieldsPerPage[index]:[];
  }

  List<CustomFormField> get allFields{
    final List<CustomFormField> fields = [];
    for(List<CustomFormField> section in _formFieldsPerPage)
      fields.addAll(section);
    return fields;
  }
}
