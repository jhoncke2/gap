part of 'entities.dart';

List<Visit> visitsFromJson(dynamic jsonVisits){
  List<Visit> visitsList;
  if(jsonVisits is List){
    visitsList = jsonVisits.map((jsonV) => Visit.fromJson(jsonV)).toList();
  }
  else if(jsonVisits is Map){
    final Map<String, dynamic> mapVisits = Map.from(jsonVisits);
    visitsList = [];
    mapVisits.forEach((key, value) {
      visitsList.add(Visit.fromJson(value));
    });
  }else
    visitsList = [];
  return visitsList;
}

/*
  Antes venían del back en formato Map, ahora las cambiaron a List.
  Tengo que actualizar este formato de visits a List, y revisar que no interfiera con otras cuestiones
  de la app.
*/
Map<String, dynamic> visitsToJson(List<Visit> visits){
  final Map<String, dynamic> json = {};
  for(int i = 0; i < visits.length; i++)
    json['$i'] = visits[i].toJson();
  return json;
}

List<Visit> visitsFromStorageJson(List<Map<String, dynamic>> jsonVisits){
  if(jsonVisits == null)
    return [];
  final List<Visit> visits = jsonVisits.map(
    (Map<String, dynamic> jV) => Visit.fromJson(jV)
  ).toList();
  return visits;
}

List<Map<String, dynamic>> visitsToStorageJson(List<Visit> visits){
  final List<Map<String, dynamic>> jsonVisits = visits.map(
    (Visit v)=>v.toJson()
  ).toList();
  return jsonVisits;
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
    completo: json['completo']??false,
    date: json['fecha'] == null? DateTime.now() : transformStringInToDate(json['fecha']),
    sede: Sede.fromJson(json['sede']),
    formularios: formulariosFromJson((json["formularios"]??[]).cast<Map<String, dynamic>>()),
  );

  factory Visit.fromFormUpdatedResponseJson(Map<String, dynamic> json)=>Visit(
    id: json['id'],
    completo: json['completo']??true,
    date: json['fecha'] == null? DateTime.now() : transformStringInToDate(json['fecha']),
    sede: Sede.fromJson(json['sede']),
  );

  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['sede'] = sede.toJson();
    json['completo'] = completo;
    json['fecha'] = transformDateInToString(date);
    json['formularios'] = formulariosToJson(formularios);
    return json;
  }

  String get stringDate => transformDateInToString(date);
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
*/