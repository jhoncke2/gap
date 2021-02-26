part of 'entities.dart';

List<Visit> visitsFromJson(dynamic visits){
  if(visits is List)
    return [];
  else{
    final Map<String, dynamic> mapVisits = Map.from(visits);
    final List<Visit> visitsAsList = [];
    mapVisits.forEach((key, value) {
      visitsAsList.add(Visit.fromJson(value));
    });
    return visitsAsList;
  }
}

Map<String, dynamic> visitsToJson(List<Visit> visits){
  final Map<String, dynamic> json = {};
  for(int i = 0; i < visits.length; i++)
    json['$i'] = visits[i].toJson();
  return json;
}

class Visit extends EntityWithStage{
  DateTime date;
  bool completo;
  Sede sede;
  List<Formulario> formularios;

  Visit({
      int id,
      this.completo,
      this.date,
      this.sede,
      this.formularios,
  }):super(
    id: id,
    stage: ProcessStage.fromValue(completo? 'realizada':'pendiente'),
    name: (sede == null)? null : sede.nombre
  );

  factory Visit.fromJson(Map<String, dynamic> json)=>Visit(
    id: json['id'],
    completo: json['completo'],
    date: _transformStringInToDate(json['fecha']),
    sede: Sede.fromJson(json['sede']),
    formularios: formulariosFromJson((json["formularios"]).cast<Map<String, dynamic>>()),
  );

  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['sede'] = sede.toJson();
    json['completo'] = (stage.value == 'realizada')? true : false;
    json['fecha'] = _transformDateInToString(date);
    json['formularios'] = formulariosToJson(formularios);
    return json;
  }

  String get stringDate => _transformDateInToString(date);
}

class Sede {
    Sede({
        this.id,
        this.nombre,
        this.departamento,
        this.ciudad,
        this.direccion,
        this.telefono,
        this.barrio,
    });

    int id;
    String nombre;
    String departamento;
    String ciudad;
    String direccion;
    String telefono;
    String barrio;

    factory Sede.fromJson(Map<String, dynamic> json) => Sede(
        id: json["id"],
        nombre: json["nombre"],
        departamento: json["departamento"],
        ciudad: json["ciudad"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        barrio: json["barrio"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "departamento": departamento,
        "ciudad": ciudad,
        "direccion": direccion,
        "telefono": telefono,
        "barrio": barrio,
    };
}

//Date format: yyyy-mm-dd
DateTime _transformStringInToDate(String stringDate){
  final List<String> stringDateParts = stringDate.split('-');
  final int year =  int.parse( stringDateParts[0] );
  final int month =  int.parse( stringDateParts[1] );
  final int day =  int.parse( stringDateParts[2] );
  final DateTime date = DateTime(year, month, day);
  return date;
}

String _transformDateInToString(DateTime date){
  return '${date.year}-${date.month}-${date.day}';
}

//TODO: Eliminar en su desuso
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

/*
Visit.fromJson(Map<String, dynamic> json)
    :
    this.date = DateTime.parse(json['date']),
    completo = json['completo'],
    sede = json['sede'],
    formularios = formulariosFromJson(json["formularios"].cast<Map<String, dynamic>>()),
    super(
      id: json['id'],
      stage:ProcessStage.fromValue(json['stage']),
      name: json['name']
    )
    ;
*/