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
      preparacion: null
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