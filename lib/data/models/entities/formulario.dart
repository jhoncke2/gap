part of 'entities.dart';

class Formulario extends EntityWithStages {
  final int id;
  final Date date;
  final FormFields _fields;
  
  Formulario.fromJson(Map<String, dynamic> json):
    id = json['id'],
    date = Date( DateTime.parse(json['date']) ),
    _fields = FormFields.fromJson( json['fields'].cast<Map<String, dynamic>>() ),
    super(
      stage: (json['stage']=='pendiente')? ProcessStage.Pendiente : ProcessStage.Realizada,
      name: json['name']
    )
    ;
 
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute} ${date.partOfDay}';
  List<FormField> get fields => _fields.formFields;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['id'] = id;
    json['name'] = name;
    json['stage'] = stage == ProcessStage.Pendiente? 'pendiente' : 'realizada';
    json['date'] = date.toString();
    json['fields'] = _fields.toJson();
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