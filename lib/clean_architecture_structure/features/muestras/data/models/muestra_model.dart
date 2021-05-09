import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';

import 'componente_model.dart';

// ignore: must_be_immutable
class MuestraModel extends Muestra{
  MuestraModel({
    @required String tipo,
    @required List<String> rangos,
    @required List<ComponenteModel> componentes,
    @required int minMuestreos,
    @required int maxMuestreos,    
    @required int nMuestreos
  }):super(
    tipo: tipo,
    rangos: rangos,
    componentes: componentes,
    minMuestreos: minMuestreos,
    maxMuestreos: maxMuestreos,    
    nMuestreos: nMuestreos
  );

  factory MuestraModel.fromJson(Map<String, dynamic> json)=>MuestraModel(
    tipo: json['tipo'],
    rangos: json['rangos'].cast<String>(),
    componentes: componentesFromJson(json),
    minMuestreos: json['n_muestreos'][0],
    maxMuestreos: json['n_muestreos'][1],
    nMuestreos: json['n_muestreos'][2]
  );
}