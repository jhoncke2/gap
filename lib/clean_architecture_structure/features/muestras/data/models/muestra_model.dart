import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';

class MuestraModel extends Muestra{
  MuestraModel({
    @required String rango,
    @required List<double> pesos
  }):super(
    rango: rango,
    pesos: pesos
  );

  factory MuestraModel.fromJson(Map<String, dynamic> json)=>MuestraModel(
    rango: json['rango'], 
    pesos: json['pesos']
  );
}