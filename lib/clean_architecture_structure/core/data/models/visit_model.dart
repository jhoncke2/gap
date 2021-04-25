import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';

List<VisitModel> visitsFromRemoteJson(dynamic jsonVisits){
  List<VisitModel> visitsList;
  if(jsonVisits is List){
    visitsList = jsonVisits.map((jsonV) => VisitModel.fromJson(jsonV)).toList();
  }
  else if(jsonVisits is Map){
    final Map<String, dynamic> mapVisits = Map.from(jsonVisits);
    visitsList = [];
    mapVisits.forEach((key, value) {
      visitsList.add(VisitModel.fromJson(value));
    });
  }else
    visitsList = [];
  return visitsList;
}

Map<String, dynamic> visitsToRemoteJson(List<VisitModel> visits){
  final Map<String, dynamic> json = {};
  for(int i = 0; i < visits.length; i++)
    json['$i'] = visits[i].toJson();
  return json;
}

List<VisitModel> visitsFromStorageJson(List<Map<String, dynamic>> jsonVisits){
  if(jsonVisits == null)
    return [];
  final List<VisitModel> visits = jsonVisits.map(
    (Map<String, dynamic> jV) => VisitModel.fromJson(jV)
  ).toList();
  return visits;
}

List<Map<String, dynamic>> visitsToStorageJson(List<VisitModel> visits){
  final List<Map<String, dynamic>> jsonVisits = visits.map(
    (VisitModel v)=>v.toJson()
  ).toList();
  return jsonVisits;
}

// ignore: must_be_immutable
class VisitModel extends Visit{
  VisitModel({
    int id,
    DateTime date,
    bool completo,
    SedeModel sede,
    List<dynamic> formularios
  }):super(
    id: id,
    date: date,
    completo: completo,
    sede: sede,
    formularios: formularios
  );
  
  factory VisitModel.fromJson(Map<String, dynamic> json)=>VisitModel(
    id: json['id'],
    completo: json['completo']??false,
    date: json['fecha_visita'] == null? DateTime.now() : transformStringInToDate(json['fecha_visita']),
    sede: SedeModel.fromJson(json['sede']),
    formularios: [],
  );

  Map<String, dynamic> toJson()=>{
    "id": id,
    'sede': (sede as SedeModel).toJson(), 
    'completo': completo,
    'fecha_visita':  transformDateInToString(date),
  };
}


class SedeModel extends Sede{
  SedeModel({
    int id,
    String nombre,
    String departamento,
    String ciudad,
    String direccion,
    String telefono,
    String barrio
  }):super(
    id: id,    
    nombre: nombre,
    departamento: departamento,
    ciudad: ciudad,
    direccion: direccion,
    telefono: telefono,
    barrio: barrio   
  );

  factory SedeModel.fromJson(Map<String, dynamic> json) => SedeModel(
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