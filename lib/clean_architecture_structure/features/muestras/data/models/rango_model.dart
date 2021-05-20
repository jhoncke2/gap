import 'package:flutter/cupertino.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';

List<RangoModel> rangosFromJson(List<Map<String, dynamic>> json) => json.map(
  (rM) => RangoModel.fromJson(rM)
).toList();

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
    nombre: json['name'],
    pesosEsperados: json['pesos_esperados'].cast<double>(),
    completo: json['completo']??false
  );
}