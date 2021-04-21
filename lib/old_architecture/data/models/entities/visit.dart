part of 'entities.dart';

List<VisitOld> visitsFromJson(dynamic jsonVisits){
  List<VisitOld> visitsList;
  if(jsonVisits is List){
    visitsList = jsonVisits.map((jsonV) => VisitOld.fromJson(jsonV)).toList();
  }
  else if(jsonVisits is Map){
    final Map<String, dynamic> mapVisits = Map.from(jsonVisits);
    visitsList = [];
    mapVisits.forEach((key, value) {
      visitsList.add(VisitOld.fromJson(value));
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

Map<String, dynamic> visitsToJson(List<VisitOld> visits){
  final Map<String, dynamic> json = {};
  for(int i = 0; i < visits.length; i++)
    json['$i'] = visits[i].toJson();
  return json;
}


List<VisitOld> visitsFromStorageJson(List<Map<String, dynamic>> jsonVisits){
  if(jsonVisits == null)
    return [];
  final List<VisitOld> visits = jsonVisits.map(
    (Map<String, dynamic> jV) => VisitOld.fromJson(jV)
  ).toList();
  return visits;
}



List<Map<String, dynamic>> visitsToStorageJson(List<VisitOld> visits){
  final List<Map<String, dynamic>> jsonVisits = visits.map(
    (VisitOld v)=>v.toJson()
  ).toList();
  return jsonVisits;
}


class VisitOld extends EntityWithStageOld{
  DateTime date;
  bool _completo;
  SedeOld sede;
  List<FormularioOld> formularios;

  VisitOld({
      int id,
      bool completo,
      this.date,
      this.sede,
      this.formularios,
  })
  :
  _completo = completo,
  super(
    id: id,
    stage: ProcessStage.fromValue(completo? 'realizada':'pendiente'),
    name: (sede == null)? null : sede.nombre
  );

  factory VisitOld.fromJson(Map<String, dynamic> json)=>VisitOld(
    id: json['id'],
    completo: json['completo']??false,
    date: json['fecha'] == null? DateTime.now() : transformStringInToDate(json['fecha']),
    sede: SedeOld.fromJson(json['sede']),
    formularios: formulariosFromJson((json["formularios"]??[]).cast<Map<String, dynamic>>()),
  );

  /*
  factory VisitOld.fromFormUpdatedResponseJson(Map<String, dynamic> json)=>VisitOld(
    id: json['id'],
    completo: json['completo']??true,
    date: json['fecha'] == null? DateTime.now() : transformStringInToDate(json['fecha']),
    sede: SedeOld.fromJson(json['sede']),
  );
  */

  @override
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['sede'] = sede.toJson();
    json['completo'] = _completo;
    json['fecha'] = transformDateInToString(date);
    json['formularios'] = formulariosToJson(formularios);
    return json;
  }

  set completo(bool completo){
    _completo = completo;
    super.stage = ProcessStage.fromValue(completo? 'realizada':'pendiente');
  }
  bool get completo => _completo;
  String get stringDate => transformDateInToString(date);
}

class SedeOld {
    SedeOld({
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

    factory SedeOld.fromJson(Map<String, dynamic> json) => SedeOld(
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