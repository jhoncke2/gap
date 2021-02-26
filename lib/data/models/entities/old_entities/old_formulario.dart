part of '../entities.dart';

class OldFormularios{
  List<OldFormulario> formularios;

  OldFormularios({
    @required this.formularios
  });

  OldFormularios.fromJson(List<Map<String, dynamic>> json){
    formularios = [];
    json.forEach((Map<String, dynamic> formularioAsJson) {
      formularios.add(OldFormulario.fromJson(formularioAsJson));
    });
  }

  List<Map<String, dynamic>> toJson() => formularios.map<Map<String, dynamic>>(
    (OldFormulario f)=>f.toJson()
  ).toList();
}

class OldFormulario extends EntityWithStage {
  final Date date;
  OldCustomFormFields fieldsContainer;
  List<PersonalInformation> firmers;
  FormStep _formStep;
  
  OldFormulario.fromJson(Map<String, dynamic> json):
    date = Date( DateTime.parse(json['date']) ),
    fieldsContainer = OldCustomFormFields.fromJson( json['fields'].cast<Map<String, dynamic>>() ),
    this.firmers = PersonalInformations.fromJson((json['firmers']??[]).cast<Map<String, dynamic>>()).personalInformations,
    super(
      id: json['id'],
      stage: ProcessStage.fromValue(json['stage']),
      name: json['name']
    ){
    _initFormStep();
  }

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
    for(OldCustomFormField ff in fieldsContainer.formFields){
      if(!ff.isFilled)
        return false;
    }
    return true;
  }

  bool _thereAreFirmers(){
    return firmers != null && firmers.length > 0;
  }
  
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute} ${date.partOfDay}';
  List<OldCustomFormField> get fields => fieldsContainer.formFields;
  FormStep get formStep => _formStep;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['id'] = id;
    json['name'] = name;
    json['stage'] = stage == ProcessStage.Pendiente? 'pendiente' : 'realizada';
    json['date'] = date.toString();
    json['fields'] = fieldsContainer.toJson();
    json['firmers'] = PersonalInformations.toJson(firmers);
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