part of 'entities.dart';

List<Formulario> formulariosFromJson(List<Map<String, dynamic>> jsonData) => List<Formulario>.from(jsonData.map((x) => Formulario.fromJson(x)));

List<Map<String, dynamic>> formulariosToJson(List<Formulario> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class Formulario extends EntityWithStage {
  bool _completo;
  final DateTime date;
  List<PersonalInformation> firmers;
  List<CustomFormField> campos;
  int formStepIndex;
  Position initialPosition;
  Position finalPosition;

  Formulario({
    int id,
    bool completo,
    String nombre,
    this.campos,
    this.date,
    this.firmers,
    int formStepIndex,
    this.initialPosition,
    this.finalPosition
  }):
  _completo = completo,
  this.formStepIndex = formStepIndex ?? 1,
  super(
    id:id,
    name: nombre,
    stage: (completo)? ProcessStage.Realizada : ProcessStage.Pendiente
  );

  factory Formulario.fromJson(Map<String, dynamic> json) => Formulario(
    id: json["formulario_pivot_id"],
    completo: json["completo"],
    nombre: json["nombre"],
    campos: customFormFieldsFromJsonString(json['campos']),
    formStepIndex: json['form_step_index'] == null? 1 : stepsInOrder.indexOf( formStepValues.map[json['form_step_index']] ),
    date: transformStringInToDate(json['fecha']??'2021-02-28'),
    firmers: PersonalInformations.fromJson((json['firmers']??[]).cast<Map<String, dynamic>>()).personalInformations,
    initialPosition: json['initial_position'] == null? null : _positionFromJson(json['initial_position']),
    finalPosition: json['final_position'] == null? null: _positionFromJson(json['final_position'])
  );

  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['formulario_pivot_id'] = id;
    json['nombre'] = name;
    json['completo'] = _completo;
    json['date'] = date.toString();
    json['firmers'] = PersonalInformations.toJson(firmers??[]);
    json['fecha'] = initialDate;
    json['campos'] = customFormFieldsToJson(campos);
    json['form_step_index'] = formStepValues.reverse[ stepsInOrder[_getIndexForJson()] ];
    json['stage'] = stage.value;
    json['initial_position'] = initialPosition == null? null : _positionToJson(initialPosition);
    json['final_position'] = initialPosition == null? null : _positionToJson(initialPosition);
    return json;
  }

  int _getIndexForJson(){
    return (stepsInOrder[formStepIndex] == FormStep.OnFirstFirmerFirm)? formStepIndex-1 : formStepIndex;
  }

  static Map<String, dynamic> _positionToJson(Position p)=>{
    'latitud':p.latitude,
    'longitud':p.longitude
  };

  static Position _positionFromJson(Map<String, dynamic> jsonP)=>Position(
    latitude: jsonP['latitud'],
    longitude: jsonP['longitud']
  );

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
    return !(cff is VariableFormField && ((cff.isRequired && cff.isCompleted) || !cff.isRequired)) || cff is StaticFormField;
  }
  
  bool get completo => _completo;
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute} Am';
  FormStep get formStep => stepsInOrder[formStepIndex];
  set formStep(FormStep formStep){
    formStepIndex = stepsInOrder.indexWhere((element) => element == formStep);
    _defineCompletoAndStage();
  }

  void advanceInStep(){
    formStepIndex = (++formStepIndex % stepsInOrder.length);
    _defineCompletoAndStage();
  }

  void _defineCompletoAndStage(){
    if(stepsInOrder[formStepIndex] == FormStep.Finished){
      _completo = true;
      stage = ProcessStage.Realizada;
    }
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
  'on_secondary_firms':FormStep.OnSecondaryFirms,
  'finished':FormStep.Finished
});