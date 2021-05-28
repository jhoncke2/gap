import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:meta/meta.dart';
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
    @required int minMuestras,
    @required int maxMuestras,    
    @required int nMuestras,
    @required int formularioInicialId,
    @required int formularioFinalId
  }):super(
    id: id,
    tipo: tipo,
    stringRangos: stringRangos,
    pesosEsperadosPorRango: pesosEsperadosPorRango,
    componentes: componentes,
    muestrasTomadas: muestrasTomadas,
    rangos: rangos,
    obligatorio: obligatorio,
    minMuestras: minMuestras,
    maxMuestras: maxMuestras,    
    nMuestras: nMuestras,
    formularioInicialId: formularioInicialId,
    formularioFinalId: formularioFinalId
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
    minMuestras: json['n_muestreos'][0],
    maxMuestras: json['n_muestreos'][1],
    nMuestras: ( json['muestras']??[] ).length,
    formularioInicialId: json['pre_formulario_id'],
    formularioFinalId: json['pos_formulario_id']
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

  @override
  Muestreo copyWith({
    int nMuestras,
    List<Rango> rangos
  })=>MuestreoModel(
    id: this.id,    
    tipo: this.tipo,
    obligatorio: this.obligatorio,
    stringRangos: this.stringRangos,
    pesosEsperadosPorRango: this.pesosEsperadosPorRango,
    componentes: this.componentes,
    muestrasTomadas: this.muestrasTomadas,
    rangos: (rangos ?? this.rangos).cast<RangoModel>(),
    minMuestras: this.minMuestras,
    maxMuestras: this.maxMuestras,
    nMuestras: nMuestras ?? this.nMuestras,
    formularioInicialId: this.formularioInicialId,
    formularioFinalId: this.formularioFinalId
  );
}