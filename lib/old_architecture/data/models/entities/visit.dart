part of 'entities.dart';

List<VisitOld> visitsFromJsonOld(dynamic jsonVisits){
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

Map<String, dynamic> visitsToJsonOld(List<VisitOld> visits){
  final Map<String, dynamic> json = {};
  for(int i = 0; i < visits.length; i++)
    json['$i'] = visits[i].toJson();
  return json;
}


List<VisitOld> visitsFromStorageJsonOld(List<Map<String, dynamic>> jsonVisits){
  if(jsonVisits == null)
    return [];
  final List<VisitOld> visits = jsonVisits.map(
    (Map<String, dynamic> jV) => VisitOld.fromJson(jV)
  ).toList();
  return visits;
}



List<Map<String, dynamic>> visitsToStorageJsonOld(List<VisitOld> visits){
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
  bool hasMuestreo;
  List<PersonalInformationOld> firmers;

  VisitOld({
    int id,
    bool completo,
    this.date,
    this.sede,
    this.formularios,
    this.hasMuestreo,
    this.firmers
  })
  :
  _completo = completo,
  super(
    id: id,
    stage: ProcessStage.fromValue(completo? 'realizada':'pendiente'),
    name: (sede == null)? null : sede.nombre
  );

  factory VisitOld.fromNewVisit(Visit v)=>VisitOld(
    id: v.id, 
    completo: 
    v.completo, 
    date: v.date, 
    sede: SedeOld(id: v.sede.id, nombre: v.sede.nombre),
    hasMuestreo: v.hasMuestreo??false,
    formularios: [],
    firmers: []
  );

  factory VisitOld.fromJson(Map<String, dynamic> json)=>VisitOld(
    id: json['id'],
    completo: json['completo']??false,
    date: json['fecha'] == null? DateTime.now() : transformStringInToDateOld(json['fecha']),
    sede: SedeOld.fromJson(json['sede']),
    formularios: formulariosFromJsonOld((json["formularios"]??[]).cast<Map<String, dynamic>>()),
    firmers: json['firmers'] != null? PersonalInformations.fromJson(json['firmers'].cast<Map<String, dynamic>>()).personalInformations : []
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
    json['fecha'] = transformDateInToStringOld(date);
    json['formularios'] = formulariosToJsonOld(formularios);
    return json;
  }

  set completo(bool completo){
    _completo = completo;
    super.stage = ProcessStage.fromValue(completo? 'realizada':'pendiente');
  }
  bool get completo => _completo;
  String get stringDate => transformDateInToStringOld(date);
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