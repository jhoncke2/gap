part of 'entities.dart';
/*
List<VisitTemp> visitsTempFromJson(dynamic visits){
  if(visits is List)
    return [];
  else{
    final Map<String, dynamic> mapVisits = Map.from(visits);
    final List<VisitTemp> visitsAsList = [];
    mapVisits.forEach((key, value) {
      visitsAsList.add(VisitTemp.fromJson(value));
    });
    return visitsAsList;
  }
}

Map<String, dynamic> visitsTempToJson(List<VisitTemp> visits){
  final Map<String, dynamic> json = {};
  for(int i = 0; i < visits.length; i++)
    json['$i'] = visits[i].toJson();
  return json;
}

class VisitTemp {
    VisitTemp({
        this.id,
        this.completo,
        this.fecha,
        this.sede,
        this.formularios,
    });

    int id;
    bool completo;
    DateTime fecha;
    Sede sede;
    List<Formulario> formularios;

    factory VisitTemp.fromJson(Map<String, dynamic> json) => VisitTemp(
        id: json["id"],
        completo: json["completo"],
        fecha: DateTime.parse(json["fecha"]),
        sede: Sede.fromJson(json["sede"]),
        formularios: formulariosFromJson(json["formularios"].cast<Map<String, dynamic>>()),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "completo": completo,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "sede": sede.toJson(),
        "formularios": List<dynamic>.from(formularios.map((x) => x)),
    };
}

class SedeTemp {
    SedeTemp({
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

    factory SedeTemp.fromJson(Map<String, dynamic> json) => SedeTemp(
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
*/