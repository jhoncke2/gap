import 'package:gap/data/models/entities/entities.dart';
import 'package:test/test.dart';

import './formularios_map.dart';

List<FormularioTemp> formularios;

void main(){
  group('Probando métodos en base a .fromJson', (){
    _testFromJson();
    _testListOfForms();
  });
}

Future _testFromJson()async{
  test('probando método fromJson', ()async{
    final List<Map<String, dynamic>> data = await getDataAsJson();
    formularios = formulariosTempFromJson(data);
  });
}

Future _testListOfForms()async{
  test('probando método fromJson', ()async{
    for(int i = 0; i < formularios.length; i++){
      _expectForm(formularios[i], i);
    }
  });
}

void _expectForm(FormularioTemp form, int formIndex){
  expect(form.id, isNotNull);
  expect(form.nombre, isNotNull);
  expect(form.completo, isNotNull);
  expect(form.campos, isNotNull);
  //if(formIndex == 0)
    //expect(form.campos.length, 0);
  //else
    //expect(form.campos.length, isNot(0));
}