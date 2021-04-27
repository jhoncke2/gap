part of 'entities.dart';

List<FormularioOld> formulariosFromJsonOld(List<Map<String, dynamic>> jsonData) => List<FormularioOld>.from(jsonData.map((x) => FormularioOld.fromJson(x)));

List<Map<String, dynamic>> formulariosToJsonOld(List<FormularioOld> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class FormularioOld extends EntityWithStageOld {
  bool _completo;
  final DateTime date;
  List<PersonalInformationOld> firmers;
  List<CustomFormFieldOld> campos;
  int formStepIndex;
  Position initialPosition;
  Position finalPosition;

  FormularioOld({
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

  factory FormularioOld.fromFormularioNew(Formulario f)=>FormularioOld(
    id: f.id,
    completo: f.completo,
    nombre: f.name,
    campos: f.campos,
    date: f.initialDate,
    firmers: f.firmers.map((f) => PersonalInformationOld(
      id: f.id, 
      name: f.name, 
      identifDocumentType: f.identifDocumentType,
      identifDocumentNumber: f.identifDocumentNumber,
      firm: f.firm
    )).toList(),
    formStepIndex: f.formStepIndex,
    initialPosition: f.initialPosition==null? null :Position(latitude: f.initialPosition.latitude, longitude: f.initialPosition.longitude),
    finalPosition: f.finalPosition==null? null : Position(latitude: f.finalPosition.latitude, longitude: f.finalPosition.longitude)
  );

  factory FormularioOld.fromJson(Map<String, dynamic> json) => FormularioOld(
    id: json["formulario_pivot_id"],
    completo: json["completo"],
    nombre: json["nombre"],
    campos: customFormFieldsFromJson(json['campos']),
    formStepIndex: _getStepIndexFromJson(json),
    date: DateTime.now(),
    firmers: PersonalInformations.fromJson((json['firmers']??[]).cast<Map<String, dynamic>>()).personalInformations,
    initialPosition: json['initial_position'] == null? null : _positionFromJson(json['initial_position']),
    finalPosition: json['final_position'] == null? null: _positionFromJson(json['final_position'])
  );

  static int _getStepIndexFromJson(Map<String, dynamic> json){
    if(json['form_step_index'] == 'on_form')
      json['form_step_index'] = 'on_form_filling_out';
    return (json['completo'])? stepsInOrderOld.length-1 : json['form_step_index'] == null? 1 : stepsInOrderOld.indexOf( formStepValuesOld.map[json['form_step_index']] );
  }

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
    json['form_step_index'] = formStepValuesOld.reverse[ stepsInOrderOld[_getIndexForJson()] ];
    json['stage'] = stage.value;
    json['initial_position'] = initialPosition == null? null : _positionToJson(initialPosition);
    json['final_position'] = finalPosition == null? null : _positionToJson(finalPosition);
    return json;
  }

  int _getIndexForJson(){
    return (stepsInOrderOld[formStepIndex] == FormStep.OnFirstFirmerFirm)? formStepIndex-1 : formStepIndex;
  }

  static Map<String, dynamic> _positionToJson(Position p)=>{
    'latitud':p.latitude,
    'longitud':p.longitude
  };

  static Position _positionFromJson(Map<String, dynamic> jsonP)=>Position(
    latitude: jsonP['latitud'],
    longitude: jsonP['longitud']
  );

  //TODO: Borrar ya que está en desuso
  bool allFieldsAreCompleted(){
    if(campos.length == 0)
      return true;
    return thoseFormFieldsAreCompleted(campos);
  }
  
  
  static bool thoseFormFieldsAreCompleted(List<CustomFormFieldOld> formFields){ 
    for(CustomFormFieldOld cff in formFields)
      if(!_formFieldIsCompleted(cff))
        return false;
    return true;
  }  

  static bool _formFieldIsCompleted(CustomFormFieldOld cff){
    return !(cff is VariableFormFieldOld && ((cff.isRequired && cff.isCompleted) || !cff.isRequired)) || cff is StaticFormFieldOld;
  }
  
  bool get completo => _completo;
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute}';
  FormStep get formStep => stepsInOrderOld[formStepIndex];
  set formStep(FormStep formStep){
    formStepIndex = stepsInOrderOld.indexWhere((element) => element == formStep);
    _defineCompletoAndStage();
  }

  void advanceInStep(){
    formStepIndex = (++formStepIndex % stepsInOrderOld.length);
    _defineCompletoAndStage();
  }

  void _defineCompletoAndStage(){
    if(stepsInOrderOld[formStepIndex] == FormStep.Finished){
      _completo = true;
      stage = ProcessStage.Realizada;
    }
  }
}

final List<FormStep> stepsInOrderOld = [
  FormStep.WithoutForm,
  FormStep.OnFormFillingOut,
  FormStep.OnFormReading,
  FormStep.OnFirstFirmerInformation,
  FormStep.OnFirstFirmerFirm,
  FormStep.OnSecondaryFirms,
  FormStep.Finished
];


final formStepValuesOld = EnumValuesOld({
  'on_form_filling_out':FormStep.OnFormFillingOut,
  //TODO: Revisar que no se rompa nada con esta adición
  'on_form_reading':FormStep.OnFormReading,
  'on_first_firmer_information':FormStep.OnFirstFirmerInformation,
  'on_secondary_firms':FormStep.OnSecondaryFirms,
  'finished':FormStep.Finished
});
