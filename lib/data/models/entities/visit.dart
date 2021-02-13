part of 'entities.dart';

class Visits{
  List<Visit> visits;

  Visits({
    @required this.visits
  });
  
  Visits.fromJson(List<Map<String, dynamic>> json){
    visits = [];
    json.forEach((Map<String, dynamic> visitAsJson) {
      visits.add(Visit.fromJson(visitAsJson));
    });
  }

  List<Map<String, dynamic>> toJson() => visits.map<Map<String, dynamic>>(
    (Visit v)=>v.toJson()
  ).toList();
}

class Visit extends EntityWithStage{
  final DateTime date;

  Visit.fromJson(Map<String, dynamic> json)
    :
    this.date = DateTime.parse(json['date']),
    super(
      id: json['id'],
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