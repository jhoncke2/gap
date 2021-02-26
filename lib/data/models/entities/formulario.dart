part of 'entities.dart';

List<Formulario> formulariosFromJson(List<Map<String, dynamic>> jsonData) => List<Formulario>.from(jsonData.map((x) => Formulario.fromJson(x)));

List<Map> formulariosToJson(List<Formulario> data) => List<Map>.from(data.map((x) => x.toJson()));

class Formulario {
    Formulario({
        this.id,
        this.completo,
        this.nombre,
        this.campos,
    });

    int id;
    bool completo;
    String nombre;
    List<CustomFormField> campos;

    factory Formulario.fromJson(Map<String, dynamic> json) => Formulario(
        id: json["formulario_pivot_id"],
        completo: json["completo"],
        nombre: json["nombre"],
        campos: customFormFieldsFromJsonString(json["campos"]),
    );

    Map<String, dynamic> toJson() => {
        "formulario_pivot_id": id,
        "completo": completo,
        "nombre": nombre,
        "campos": campos,
    };
}