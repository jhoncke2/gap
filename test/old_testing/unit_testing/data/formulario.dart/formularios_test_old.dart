import 'dart:convert';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:test/test.dart';

import 'formularios_map.dart';

List<Map<String, dynamic>> initialJsonData;
List<FormularioOld> formularios;

/*
void main(){
  group('Probando métodos en base a .fromJson', (){
    _testFromJson();
    _testListOfForms();
  });
}
*/

Future _testFromJson()async{
  test('probando método fromJson', ()async{
    initialJsonData = await getDataAsJson();
    formularios = formulariosFromJsonOld(initialJsonData);
  });
}

Future _testListOfForms()async{
  test('probando método fromJson', ()async{
    for(int i = 0; i < formularios.length; i++){
      _expectForm(formularios[i], i);
    }
  });
}

void _expectForm(FormularioOld form, int formIndex){
  expect(form.id, isNotNull);
  expect(form.name, isNotNull);
  expect(form.completo, isNotNull);
  expect(form.campos, isNotNull);
  _expectToJson(form, formIndex);
  //if(formIndex == 0)
    //expect(form.campos.length, 0);
  //else
    //expect(form.campos.length, isNot(0));
}

void _expectToJson(FormularioOld f, int formIndex){
  final Map<String, dynamic> initialJson = initialJsonData[formIndex];
  final Map<String, dynamic> jsonF = f.toJson();
  expect( jsonF['formulario_pivot_id'] , initialJson['formulario_pivot_id'] );
  expect(jsonF['nombre'], initialJson['nombre']);
  expect(jsonF['completo'], initialJson['completo']);
  _expectCampos(initialJson, jsonF);
}

void _expectCampos(Map<String, dynamic> initialJson, Map<String, dynamic> jsonF){
  final List<Map<String, dynamic>> jsonFCampos = jsonDecode( jsonF['campos'] ).cast<Map<String, dynamic>>();
  final List<Map<String, dynamic>> initialJsonCampos = jsonDecode( initialJson['campos'] ).cast<Map<String, dynamic>>();
  jsonFCampos.forEach(
    (Map<String, dynamic> jfc){
      _transformCurrentFormFieldJson(jfc);
    }
  );
  initialJsonCampos.forEach(
    (Map<String, dynamic> ijc){
      _transformWildFormFIeldJson(ijc);
    }
  );
  expect(jsonFCampos.length, initialJsonCampos.length);
}

void _transformCurrentFormFieldJson(Map<String, dynamic> formFieldJson){
  formFieldJson.removeWhere((key, value) => value == null);
}

void _transformWildFormFIeldJson(Map<String, dynamic> json){
  json.remove('access');
  json.remove('className');
}

