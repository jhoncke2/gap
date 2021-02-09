part of 'entities.dart';

class Visit extends EntityWithStages{
  final DateTime date;

  Visit.fromJson(Map<String, dynamic> json)
    :
    this.date = DateTime.parse(json['date']),
    super(
      stage: (json['stage']=='pendiente')? ProcessStage.Pendiente : ProcessStage.Realizada,
      name: json['name']
    )
    ;

  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['date'] = date.toString();
    return json;
  }
}