import 'package:gap/logic/enums/process_stage.dart';
import 'package:gap/logic/models/entities/EntityWithStages.dart';
import 'package:gap/logic/models/entities/form_field.dart';

class Formulario extends EntityWithStages {
  final int id;
  final Date date;
  final List<FormField> fields;
  
  Formulario.fromJson({Map<String, dynamic> json}):
    this.id = json['id'],
    this.date = Date( DateTime.parse(json['date']) ),
    this.fields = FormFields.fromJson( json['fields'].cast<Map<String, dynamic>>() ).formsFields,
    super(
      stage: (json['step']=='pendiente')? ProcessStage.Pendiente : ProcessStage.Realizada,
      name: json['name']
    )
    ;
 
  String get initialDate => '${date.year}-${date.month}-${date.day}';
  String get initialTime => '${date.hour}:${date.minute} ${date.partOfDay}';
}

class Date{
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final String partOfDay; //AM o PM

  Date(DateTime dateTime):
    this.year = dateTime.year,
    this.month = dateTime.month,
    this.day = dateTime.day,
    this.hour = dateTime.hour % 12,
    this.minute = dateTime.minute,
    this.partOfDay = dateTime.hour > 12 ? 'AM' : 'PM'
    ;
}