enum VisitStep{
  Pendiente,
  Realizada
}

class Visit{
  final String name;
  final DateTime date;
  final VisitStep state;

  Visit.fromJson(Map<String, dynamic> json):
    this.name = json['name'],
    this.date = DateTime.parse(json['fecha']),
    this.state = json['step'] == 'pendiente'? VisitStep.Pendiente : VisitStep.Realizada 
    ;
}