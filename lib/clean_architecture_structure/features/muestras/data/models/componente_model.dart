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
    String preparacion
  }):super(
    nombre: nombre,
    preparacion: preparacion
  );

  factory ComponenteModel.fromJson(Map<String, dynamic> json)=>ComponenteModel(
    nombre: json['componentes'] == null ? [] : json['componentes'][json['componente_index']],
    preparacion: null
  );

}