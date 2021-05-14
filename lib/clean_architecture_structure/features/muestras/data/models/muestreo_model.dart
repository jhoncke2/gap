import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_toma_model.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

import 'componente_model.dart';
import 'muestra_model.dart';

// ignore: must_be_immutable
class MuestreoModel extends Muestreo{
  MuestreoModel({
    @required String tipo,
    @required List<String> rangos,
    @required List<List<double>> pesosEsperadosPorRango,
    @required List<ComponenteModel> componentes,
    @required List<MuestraModel> muestrasTomadas,
    @required bool obligatorio,
    @required int minMuestreos,
    @required int maxMuestreos,    
    @required int nMuestreos
  }):super(
    tipo: tipo,
    rangos: rangos,
    pesosEsperadosPorRango: pesosEsperadosPorRango,
    componentes: componentes,
    muestrasTomadas: muestrasTomadas,
    obligatorio: obligatorio,
    minMuestras: minMuestreos,
    maxMuestras: maxMuestreos,    
    nMuestras: nMuestreos
  );

  factory MuestreoModel.fromJson(Map<String, dynamic> json)=>MuestreoModel(
    tipo: json['tipo'],
    rangos: json['rangos'].cast<String>(),
    pesosEsperadosPorRango: _getPesosEsperadosFromJson(json),
    componentes: componentesFromJson(json),
    muestrasTomadas: json['muestras_tomadas']??[],
    obligatorio: json['obligatorio'],
    minMuestreos: json['n_muestreos'][0],
    maxMuestreos: json['n_muestreos'][1],
    nMuestreos: json['n_muestreos'][2]
  );

  static List<List<double>> _getPesosEsperadosFromJson(Map<String, dynamic> json){
    List<List> list = (json['pesos_esperados'] as List).cast<List>();
    List<List<double>> doubleList = list.map(
      (l)=> l.map(
        (p) => (p as num).toDouble()
      ).toList()
    ).toList();
    return doubleList;
  }

  Map<String, dynamic> toRemoteJson(int selectedRangoIndex){
    Map<String, dynamic> json = {'tipo_rango':selectedRangoIndex};
    List<double> pesos = [];
    json['pesos'] = pesos;
    componentes.forEach((c) {
      RangoTomaModel rangoToma = c.valoresPorRango.singleWhere((rT) => rT.rango == rangos[selectedRangoIndex]);
      pesos.add(rangoToma.pesosTomados.last);
    });
    return json;
  }
}