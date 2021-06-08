import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';

List<MuestraModel> muestrasFromJson(List<Map<String, dynamic>> json)=>json.map(
  (j)=>MuestraModel.fromJson(j)
).toList();

List<Map<String, dynamic>> muestrasToJson(List<MuestraModel> muestras) => muestras.map(
  (m) => m.toJson()
).toList();

class MuestraModel extends Muestra{
  MuestraModel({
    @required int id,
    @required String rango,
    @required List<double> pesos
  }):super(
    id: id,
    rango: rango,
    pesos: pesos
  );

  factory MuestraModel.fromJson(Map<String, dynamic> json)=>MuestraModel(
    id: json['id'],
    rango: json['rango'], 
    pesos: (json['resultados'] as List).map(
      (p)=> (p as num).toDouble()
    ).toList()
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'rango': this.rango,
    'resultados': this.pesos
  };
}