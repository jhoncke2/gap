import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:test/test.dart';

OldFormulario testingForm;

void main(){
  _testFalseFieldsAreCompleted();
  _testTrueFieldsAreCompleted();
  _testFormStep();
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
  testingForm = OldFormulario.fromJson(fakeData.formAtFormFieldsFillingOut);
  // ignore: invalid_use_of_protected_member
  expect(testingForm.fieldsAreCompleted(), false, reason: 'el método deberia dar false, pues los fields no están completos');
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
  testingForm = OldFormulario.fromJson(fakeData.formAtFirstFirmerFillingOut);
  // ignore: invalid_use_of_protected_member
  expect(testingForm.fieldsAreCompleted(), true, reason: 'el método deberia dar true, pues los fields sí están completos');
}

void _testFormStep(){
  test('Se testeará el método are completed esperando que dé false', (){
    _tryTestFormStep();
  });
} 

void _tryTestFormStep(){
  testingForm = OldFormulario.fromJson(fakeData.formAtFormFieldsFillingOut);
  expect(testingForm.formStep, FormStep.OnForm, reason: 'El form step del formulario debe ser: on Form');
  testingForm = OldFormulario.fromJson(fakeData.formAtFirstFirmerFillingOut);
  expect(testingForm.formStep, FormStep.OnFirstFirmerInformation, reason: 'El form step del formulario debe ser: on iirst iirmer information');
  testingForm = OldFormulario.fromJson(fakeData.formAtSecondaryFirmersFillingOut);
  expect(testingForm.formStep, FormStep.OnSecondaryFirms, reason: 'El form step del formulario debe ser: on secondary firms');
}