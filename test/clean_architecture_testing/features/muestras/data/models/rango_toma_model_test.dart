import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_toma_model.dart';
import '../../../../fixtures/fixture_reader.dart';

Map<String, dynamic> tJson;
RangoTomaModel tExpectedRangoToma;
RangoTomaModel tRangoToma;

void main(){
  setUp((){
    tJson = _getMuestraFromFixture();
    tJson['componente_index'] = 0;
    tJson['rango_index'] = 1;
    tExpectedRangoToma = RangoTomaModel(
      rango: tJson['rangos'][1],
      pesoEsperado: (tJson['pesos_esperados'][1][0] as num).toDouble(),
      pesosTomados: []
    );
    tRangoToma = RangoTomaModel.fromJson(tJson);
  });

  test('should be the expected', (){
    expect(tRangoToma, tExpectedRangoToma);
  });
}

Map<String, dynamic> _getMuestraFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  return jsonDecode(stringMuestra).cast<String, dynamic>();
}