import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';

List<ComponenteModel> componentesFromRemoteJson(Map<String, dynamic> json){
  List<ComponenteModel> componentes = [];
  final List<String> componentesNombres = (json['componentes']??[]).cast<String>();
  if(componentesNombres != null){
    return componentesNombres.map(
      (cN) => ComponenteModel.fromName(cN)
    ).toList();
    /*
    for(int i = 0; i < componentesNombres.length; i++){
      json['componente_index'] = i;
      componentes.add(ComponenteModel.fromJson(json));
    }
    */
  }
  return componentes;
}

List<ComponenteModel> componentesFromLocalJson(List<Map<String, dynamic>> json) =>
  json.map((cM) => ComponenteModel.fromJson(cM)).toList();

List<Map<String, dynamic>> componentesToLocalJson(List<ComponenteModel> compModels) =>
  compModels.map((cM) => cM.toJson()).toList();

// ignore: must_be_immutable
class ComponenteModel extends Componente{
  ComponenteModel({
    String nombre,
    String preparacion
  }):super(
    nombre: nombre,
    preparacion: preparacion
  );

  factory ComponenteModel.fromName(String componenteNombre)=>ComponenteModel(
    //nombre: json['componentes'] == null ? [] : json['componentes'][json['componente_index']],
    nombre: componenteNombre,
    preparacion: null
  );

  factory ComponenteModel.fromJson(Map<String, dynamic> json) => ComponenteModel(
    nombre: json['nombre'],
    preparacion: json['preparacion']
  );

  Map<String, dynamic> toJson() => {
    'nombre': this.nombre,
    'preparacion': this.preparacion
  };

}