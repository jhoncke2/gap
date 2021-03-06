import 'package:flutter/cupertino.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';

List<RangoModel> rangosFromJson(List<Map<String, dynamic>> json) => json.map(
  (rM) => RangoModel.fromJson(rM)
).toList();

List<Map<String, dynamic>> rangosToJson(List<RangoModel> rangos) => rangos.map(
  (r) => r.toJson()
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
    //Por si pesos vienen como strings o como doubles
    pesosEsperados: (json['pesos_esperados'].map(
      (pE) => double.parse( pE.toString() )
    ).toList() ).cast<double>(),
    completo: json['completo']??false
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'name': this.nombre,
    'pesos_esperados': this.pesosEsperados,
    'completo': this.completo
  };

  @override
  RangoModel copyWith({
    int id,
    String nombre,
    List<double> pesosEsperados,
    bool completo
  })=>RangoModel(
    id: this.id, 
    nombre: this.nombre, 
    pesosEsperados: this.pesosEsperados, 
    completo: this.completo
  );
}