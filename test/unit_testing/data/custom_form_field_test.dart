import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';
import 'package:test/test.dart';

CustomFormField formField;

void main(){
  _testTextFormField();
  _testSelectFormField();
}

void _testTextFormField(){
  test('se testeará un form field text', (){
    _tryTestFormField();
  });
}

void _tryTestFormField(){
  final Map<String, dynamic> formFieldAsMap = fakeData.formFieldsAsMapList[0];
  formField = CustomFormField.fromJson(formFieldAsMap);
  _compararFormFields(formField, formFieldAsMap);
}

void _compararFormFields(CustomFormField f1, Map<String, dynamic> f2){
  expect(f1.toJson(), f2, reason: 'En toJson del objeto deberia ser igual al json original');
}

void _testSelectFormField(){
  test('se testeará un form field text', (){
    _tryTestSelectFormField();
  });
}

void _tryTestSelectFormField(){
  final Map<String, dynamic> formFieldAsMap = fakeData.formFieldsAsMapList[0];
  formField = CustomFormField.fromJson(formFieldAsMap);
  _compararFormFields(formField, formFieldAsMap);
}