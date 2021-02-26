part of 'entities.dart';

List<FormularioTemp> formulariosTempFromJson(List<Map<String, dynamic>> jsonData) => List<FormularioTemp>.from(jsonData.map((x) => FormularioTemp.fromJson(x)));

List<Map> formulariosTempToJson(List<FormularioTemp> data) => List<Map>.from(data.map((x) => x.toJson()));

class FormularioTemp {
    FormularioTemp({
        this.id,
        this.completo,
        this.nombre,
        this.campos,
    });

    int id;
    bool completo;
    String nombre;
    List<CustomFormField> campos;

    factory FormularioTemp.fromJson(Map<String, dynamic> json) => FormularioTemp(
        id: json["formulario_pivot_id"],
        completo: json["completo"],
        nombre: json["nombre"],
        //campos: customFormFieldsFromJsonString(json["campos"].toString()),
        campos: []
    );

    Map<String, dynamic> toJson() => {
        "formulario_pivot_id": id,
        "completo": completo,
        "nombre": nombre,
        "campos": campos,
    };
}