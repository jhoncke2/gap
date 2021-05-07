import 'dart:convert';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_toma_model.dart';
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/componente_model.dart';
import '../../../../fixtures/fixture_reader.dart';

Map<String, dynamic> tJson;
ComponenteModel tExpectedComponente;
ComponenteModel tComponente;

void main(){
  setUp((){
    tJson = _getMuestraFromFixture();
    tExpectedComponente = ComponenteModel(
      nombre: tJson['componentes'][0],
      preparacion: null,
      valoresPorRango: [
        RangoTomaModel(
          rango: tJson['pesos_esperados'][0]['rango'],
          pesoEsperado: (tJson['pesos_esperados'][0]['pesos'][0] as num).toDouble(),
          pesosTomados: []
        ),
        RangoTomaModel(
          rango: tJson['pesos_esperados'][1]['rango'],
          pesoEsperado: (tJson['pesos_esperados'][1]['pesos'][0] as num).toDouble(),
          pesosTomados: []
        ),
        RangoTomaModel(
          rango: tJson['pesos_esperados'][2]['rango'],
          pesoEsperado: (tJson['pesos_esperados'][2]['pesos'][0] as num).toDouble(),
          pesosTomados: []
        )
      ]
    );
    tJson['componente_index'] = 0;
    tComponente = ComponenteModel.fromJson(tJson);
  });

  test('should have the specified values', (){
    expect(tComponente, tExpectedComponente);
  });
}

Map<String, dynamic> _getMuestraFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  return jsonDecode(stringMuestra).cast<String, dynamic>();
}