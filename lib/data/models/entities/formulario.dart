part of 'entities.dart';

List<Formulario> formulariosFromJson(List<Map<String, dynamic>> jsonData) => List<Formulario>.from(jsonData.map((x) => Formulario.fromJson(x)));

List<Map<String, dynamic>> formulariosToJson(List<Formulario> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class Formulario extends EntityWithStage {
  bool completo;
  final DateTime date;
  List<PersonalInformation> firmers;
  FormStep _formStep;
  List<CustomFormField> campos;
  int formStepIndex;

  Formulario({
    int id,
    this.completo,
    String nombre,
    this.campos,
    ProcessStage stage,
    this.date,
    this.firmers,
    int formStepIndex
  }):
  this.formStepIndex = formStepIndex ?? 1,
  super(
    id:id,
    name: nombre,
    stage:stage
  );

  factory Formulario.fromJson(Map<String, dynamic> json) => Formulario(
    id: json["formulario_pivot_id"],
    completo: json["completo"],
    nombre: json["nombre"],
    //campos: customFormFieldsFromJsonString(json["campos"].toString()),
    campos: customFormFieldsFromJsonString(json['campos']),
    formStepIndex: json['form_step_index'] == null? 1 : stepsInOrder.indexOf( formStepValues.map[json['form_step_index']] ),
    date: transformStringInToDate(json['fecha']??'2021-02-28'),
    firmers: PersonalInformations.fromJson((json['firmers']??[]).cast<Map<String, dynamic>>()).personalInformations
  );

  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['formulario_pivot_id'] = id;
    json['nombre'] = name;
    json['completo'] = stage == ProcessStage.Realizada? true : false;
    json['date'] = date.toString();
    json['firmers'] = PersonalInformations.toJson(firmers??[]);
    json['fecha'] = initialDate;
    json['campos'] = customFormFieldsToJson(campos);
    json['form_step_index'] = formStepValues.reverse[ stepsInOrder[_getIndexForJson()] ];
    return json;
  }

  int _getIndexForJson(){
    return (stepsInOrder[formStepIndex] == FormStep.OnFirstFirmerFirm)? formStepIndex-1 : formStepIndex;
  }

  bool allFieldsAreCompleted(){
    if(campos.length == 0)
      return true;
    return thoseFormFieldsAreCompleted(campos);
  }

  static bool thoseFormFieldsAreCompleted(List<CustomFormField> formFields){
    for(CustomFormField cff in formFields)
      if(!_formFieldIsCompleted(cff))
        return false;
    return true;
  }

  static bool _formFieldIsCompleted(CustomFormField cff){
    return !(cff is VariableFormField && cff.isRequired && !cff.isCompleted);
  }
  
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute} Am';
  FormStep get formStep => stepsInOrder[formStepIndex];
  set formStep(FormStep formStep){
    formStepIndex = stepsInOrder.indexWhere((element) => element == formStep);
  }

  void advanceInStep(){
    formStepIndex = (++formStepIndex % stepsInOrder.length);
  }
}

final List<FormStep> stepsInOrder = [
  FormStep.WithoutForm,
  FormStep.OnForm,
  FormStep.OnFirstFirmerInformation,
  FormStep.OnFirstFirmerFirm,
  FormStep.OnSecondaryFirms,
  FormStep.Finished
];

final formStepValues = EnumValues({
  'on_form':FormStep.OnForm,
  'on_first_firmer_information':FormStep.OnFirstFirmerInformation,
  'on_secondary_firms':FormStep.OnSecondaryFirms
});