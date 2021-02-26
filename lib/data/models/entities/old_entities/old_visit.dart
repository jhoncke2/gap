part of '../entities.dart';

class OldVisits{
  List<OldVisit> visits;

  OldVisits({
    @required this.visits
  });
  
  OldVisits.fromJson(List<Map<String, dynamic>> json){
    visits = [];
    json.forEach((Map<String, dynamic> visitAsJson) {
      visits.add(OldVisit.fromJson(visitAsJson));
    });
  }

  List<Map<String, dynamic>> toJson() => visits.map<Map<String, dynamic>>(
    (OldVisit v)=>v.toJson()
  ).toList();
}

class OldVisit extends EntityWithStage{
  final DateTime date;

  OldVisit.fromJson(Map<String, dynamic> json)
    :
    this.date = DateTime.parse(json['date']),
    super(
      id: json['id'],
      stage:ProcessStage.fromValue(json['stage']),
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