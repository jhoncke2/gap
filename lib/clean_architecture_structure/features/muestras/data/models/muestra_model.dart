import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';

import 'componente_model.dart';

class MuestraModel extends Muestra{
  MuestraModel({
    String tipo,
    List<String> rangos,
    List<ComponenteModel> componentes,
    int nMuestreos
  }):super(
    tipo: tipo,
    rangos: rangos,
    componentes: componentes,
    nMuestreos: nMuestreos
  );

  factory MuestraModel.fromJson(Map<String, dynamic> json)=>MuestraModel(
    tipo: json['tipo'],
    rangos: json['rangos'].cast<String>(),
    componentes: componentesFromJson(json),
    nMuestreos: 0
  );
}