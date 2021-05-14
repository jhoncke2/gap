import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_toma_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';

List<ComponenteModel> componentesFromJson(Map<String, dynamic> json){
  List<ComponenteModel> componentes = [];
  final List componentesNombres = json['componentes'];
  for(int i = 0; i < componentesNombres.length; i++){
    json['componente_index'] = i;
    componentes.add(ComponenteModel.fromJson(json));
  }
  return componentes;
}

// ignore: must_be_immutable
class ComponenteModel extends Componente{
  ComponenteModel({
    String nombre,
    List<RangoTomaModel> valoresPorRango,
    String preparacion
  }):super(
    nombre: nombre,
    valoresPorRango: valoresPorRango,
    preparacion: preparacion
  );

  factory ComponenteModel.fromJson(Map<String, dynamic> json)=>ComponenteModel(
    nombre: json['componentes'] == null ? [] : json['componentes'][json['componente_index']],
    valoresPorRango: ([null, []].contains( json['componentes'] ))? [] : rangoTomaModelsFromJson(json),
    preparacion: null
  );

}