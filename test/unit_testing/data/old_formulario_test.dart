import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';
import 'package:test/test.dart';

Formulario testingForm;

void main(){
  _testFalseFieldsAreCompleted();
  _testTrueFieldsAreCompleted();
}

void _testFalseFieldsAreCompleted(){
  test('Se testeará el método are completed esperando que dé false', (){
    try{
      _tryTestFalseFieldsAreCompleted();
    }catch(err){
      throw err;
    }
  });
}

void _tryTestFalseFieldsAreCompleted(){
  testingForm = Formulario.fromJson(fakeData.formAtFormFieldsFillingOut);
  // ignore: invalid_use_of_protected_member
  expect(testingForm.allFieldsAreCompleted(), false, reason: 'el método deberia dar false, pues los fields no están completos');
}

void _testTrueFieldsAreCompleted(){
  test('Se testeará el método are completed esperando que dé false', (){
    try{
      _tryTestTrueFieldsAreCompleted();
    }catch(err){
      throw err;
    }
  });
}

void _tryTestTrueFieldsAreCompleted(){
  testingForm = Formulario.fromJson(fakeData.formAtFirstFirmerFillingOut);
  // ignore: invalid_use_of_protected_member
  expect(testingForm.allFieldsAreCompleted(), true, reason: 'el método deberia dar true, pues los fields sí están completos');
}