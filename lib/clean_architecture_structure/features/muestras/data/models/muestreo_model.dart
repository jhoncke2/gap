import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_model.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'componente_model.dart';
import 'muestra_model.dart';

// ignore: must_be_immutable
class MuestreoModel extends Muestreo{
  MuestreoModel({
    @required int id,
    @required String tipo,
    @required List<String> stringRangos,
    @required List<List<double>> pesosEsperadosPorRango,
    @required List<ComponenteModel> componentes,
    @required List<MuestraModel> muestrasTomadas,
    @required List<RangoModel> rangos,
    @required bool obligatorio,
    @required int minMuestreos,
    @required int maxMuestreos,    
    @required int nMuestreos
  }):super(
    id: id,
    tipo: tipo,
    stringRangos: stringRangos,
    pesosEsperadosPorRango: pesosEsperadosPorRango,
    componentes: componentes,
    muestrasTomadas: muestrasTomadas,
    rangos: rangos,
    obligatorio: obligatorio,
    minMuestras: minMuestreos,
    maxMuestras: maxMuestreos,    
    nMuestras: nMuestreos
  );

  factory MuestreoModel.fromJson(Map<String, dynamic> json)=>MuestreoModel(
    id: json['id'],
    tipo: json['tipo'],
    stringRangos: [''],
    pesosEsperadosPorRango: _getPesosEsperadosFromJson(json),
    componentes: componentesFromJson(json),
    rangos:  rangosFromJson( json['rangos'].cast<Map<String, dynamic>>() ),
    muestrasTomadas: json['muestras'] != null? muestrasFromJson(json['muestras'].cast<Map<String, dynamic>>()): [],
    obligatorio: json['obligatorio'],
    minMuestreos: json['n_muestreos'][0],
    maxMuestreos: json['n_muestreos'][1],
    nMuestreos: ( json['muestras']??[] ).length
  );

  static List<List<double>> _getPesosEsperadosFromJson(Map<String, dynamic> json){
    List<List> list = (json['pesos_esperados'] as List).cast<List>();
    List<List<double>> doubleList = list.map(
      (l)=> l.map(
        //En caso de que vengan como string o como num
        (p) => (num.parse(p.toString())).toDouble()
      ).toList()
    ).toList();
    return doubleList;
  }
}