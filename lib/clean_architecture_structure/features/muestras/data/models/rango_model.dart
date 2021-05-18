import 'package:flutter/cupertino.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';

class RangoModel extends Rango{
  RangoModel({
    @required int id,
    @required String nombre,
    @required List<double> pesosEsperados,
    @required bool completo
  }):super(
    id: id,
    nombre: nombre,
    pesosEsperados: pesosEsperados,
    completo: completo
  );

  factory RangoModel.fromJson(Map<String, dynamic> json)=>RangoModel(
    id: json['id'],
    nombre: json['nombre'],
    pesosEsperados: json['pesos_esperados'].cast<double>(),
    completo: json['completo']
  );
}