part of 'entities.dart';

List<Formulario> formulariosFromJson(List<Map<String, dynamic>> jsonData) => List<Formulario>.from(jsonData.map((x) => Formulario.fromJson(x)));

List<Map<String, dynamic>> formulariosToJson(List<Formulario> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class Formulario extends EntityWithStage {
  bool completo;
  //TODO: Eliminar en su desuso
  final Date dateOld = Date(DateTime.now());
  final DateTime date;
  OldCustomFormFields fieldsContainer = OldCustomFormFields([]);
  List<PersonalInformation> firmers;
  FormStep _formStep;
  List<CustomFormField> campos;

  Formulario({
    int id,
    this.completo,
    String nombre,
    this.campos,
    ProcessStage stage,
    this.date,
    this.firmers
  }):super(
    id:id,
    name: nombre,
    stage:stage
  ){
    _initFormStep();
  }

  factory Formulario.fromJson(Map<String, dynamic> json) => Formulario(
        id: json["formulario_pivot_id"],
        completo: json["completo"],
        nombre: json["nombre"],
        //campos: customFormFieldsFromJsonString(json["campos"].toString()),
        campos: customFormFieldsFromJsonString(json['campos']),
        //campos: [],
        date: _transformStringInToDate(json['fecha']??'2021-02-28'),
        firmers: PersonalInformations.fromJson((json['firmers']??[]).cast<Map<String, dynamic>>()).personalInformations
    );

  void _initFormStep(){
    if(fieldsAreCompleted()){
      if(!_thereAreFirmers())
        _formStep = FormStep.OnFirstFirmerInformation;
      else
        _formStep = FormStep.OnSecondaryFirms;
    }else{
      _formStep = FormStep.OnForm;
    }
  }

  @protected
  bool fieldsAreCompleted(){
    for(CustomFormField cff in campos){
      if(cff is VariableFormField)
        if(cff.isRequired && !cff.isCompleted)
          return false;
    }
    return true;
  }

  bool _thereAreFirmers(){
    return firmers != null && firmers.length > 0;
  }
  
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute} Am';
  List<OldCustomFormField> get fields => fieldsContainer.formFields;
  FormStep get formStep => _formStep;
  
  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['formulario_pivot_id'] = id;
    json['nombre'] = name;
    json['completo'] = stage == ProcessStage.Realizada? true : false;
    json['date'] = date.toString();
    json['fields'] = fieldsContainer.toJson();
    json['firmers'] = PersonalInformations.toJson(firmers??[]);
    json['fecha'] = initialDate;
    json['campos'] = customFormFieldsToJson(campos);
    return json;
  }
}

class Date{
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final String partOfDay; //AM o PM
  final String _stringDateTime;

  Date(DateTime dateTime):
    this.year = dateTime.year,
    this.month = dateTime.month,
    this.day = dateTime.day,
    this.hour = dateTime.hour % 12,
    this.minute = dateTime.minute,
    this.partOfDay = dateTime.hour > 12 ? 'AM' : 'PM',
    this._stringDateTime = dateTime.toString()
    ;

  String toString() => _stringDateTime;
}


//TODO: Eliminar en su desuso

/*
Formulario.fromJson(Map<String, dynamic> json):
  dateOld = Date( DateTime.parse(json['date']) ),
  fieldsContainer = OldCustomFormFields.fromJson( json['fields'].cast<Map<String, dynamic>>() ),
  this.firmers = PersonalInformations.fromJson((json['firmers']??[]).cast<Map<String, dynamic>>()).personalInformations,
  super(
    id: json['id'],
    stage: ProcessStage.fromValue(json['completo']?'realizada':'pendiente'),
    name: json['name']
  ){
  _initFormStep();
}



*/