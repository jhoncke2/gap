import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';

List<RangoTomaModel> rangoTomaModelsFromJson(Map<String, dynamic> json){
  List<RangoTomaModel> rangoTomas = [];
  final List rangos = json['rangos'];
  for(int i = 0; i < rangos.length; i++){
    json['rango_index'] = i;
    rangoTomas.add(RangoTomaModel.fromJson(json));
  }
  return rangoTomas;
}

class RangoTomaModel extends RangoToma{
  RangoTomaModel({
    String rango,
    double pesoEsperado,
    List<double> pesosTomados,
  }):super(
    rango: rango,
    pesoEsperado: pesoEsperado,
    pesosTomados: pesosTomados
  );

  factory RangoTomaModel.fromJson(Map<String, dynamic> json)=>RangoTomaModel(
    rango: json['rangos'][json['rango_index']],
    pesoEsperado: ( json['pesos_esperados'] == null || (json['pesos_esperados'] as List).isEmpty)? null 
        : (json['pesos_esperados'][json['rango_index']][json['componente_index']] as num).toDouble(),
    pesosTomados: []
  );
}