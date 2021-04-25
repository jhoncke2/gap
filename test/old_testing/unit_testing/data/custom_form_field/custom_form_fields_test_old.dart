import 'dart:convert';

import 'package:gap/old_architecture/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/select.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:test/test.dart';

import 'package:gap/old_architecture/data/models/entities/entities.dart';
// Para lectura de archivo de data.
import 'cocar_form_fields_data.dart';
import 'custom_form_fields_string.dart';
//*********** ************

List<CustomFormFieldOld> formFields;
List<Map<String, dynamic>> initialJsonFormFields;
int numberOfElementsTraveled = 0;
int nHeaders = 0;
int nParagraphs = 0;
int nTexts = 0;
int nTextAreas = 0;
int nNumbers = 0;
int nDates = 0;
int nTimes = 0;
int nCheckBoxGroups = 0;
int nRadioGroups = 0;
int nSelects = 0;

String typesWithMax = '[';
String typesWithMaxLength = '[';
String typesWithInLine = '[';

/*
void main(){
  group('Se testeará el .fromJson y se verificarán cualidades de los elementos de la lista.', (){
    _testFromJson();
    _testCustFormFieldElements();
  });
  
}
*/

Future _testFromJson()async{
  test('Se testeará el .fromJson de una lista de customFormFields', ()async{
    await _tryFromJson();
  });
}

Future _tryFromJson()async{
  final String dataAsString = await getDataAsString();
  //final String dataAsString = getCocarDataAsString();
  formFields = customFormFieldsFromJson(dataAsString);
  initialJsonFormFields = jsonDecode(dataAsString).cast<Map<String, dynamic>>();
  expect(formFields, isNotNull, reason: 'Los formFields no deben ser null');
  expect(formFields.length, isNot(0), reason: 'La cantidad de custom form fields debe ser mayor a 0');
}

Future _testCustFormFieldElements()async{
  test('Se testeará el .fromJson de una lista de customFormFields', ()async{
    try{ 
      await _tryTestCustFormFieldElements();
    }catch(err){
      print('Número de elementos recorridos. $numberOfElementsTraveled');
      final CustomFormFieldOld errCustomFormField = formFields[numberOfElementsTraveled-1];
      print('Elemento con error: ');
      print(errCustomFormField.toJson().toString());
      throw err;
    }
  });
}

Future _tryTestCustFormFieldElements()async{
  for(CustomFormFieldOld cff in formFields)
    _expectCustomFormField(cff);
  _printNElementsOfEveryType();
}

void _expectCustomFormField(CustomFormFieldOld cff){
  numberOfElementsTraveled++;
  expect(cff, isNotNull, reason: 'El custom form field actual no debe ser null');
  expect(cff.label, isNotNull, reason: 'El label del field no debe ser null');
  //expect(cff.isRequired, isNotNull, reason: 'El isRequired del field no debe ser null');
  final FormFieldTypeOld fieldType = cff.type;
  expect(fieldType, isNotNull, reason: 'El type del form field no debe ser null');
  _expectByType(cff, fieldType);
  _printNotRequiredVariables(cff);
}

void _expectByType(CustomFormFieldOld cff, FormFieldTypeOld type){
  switch(type){
    case FormFieldTypeOld.HEADER:
      _expectHeaderField(cff);
      break;
    case FormFieldTypeOld.PARAGRAPH:
      _expectParagraphField(cff);
      break;
    case FormFieldTypeOld.SINGLE_TEXT:
      _expectTextField(cff);
      break;
    case FormFieldTypeOld.TEXT_AREA:
      _expectTextAreaField(cff);
      break;
    case FormFieldTypeOld.NUMBER:
      _expectNumberField(cff);
      break;
    case FormFieldTypeOld.DATE:
      _expectDateField(cff);
      break;
    case FormFieldTypeOld.TIME:
      _expectTimeField(cff);
      break;
    case FormFieldTypeOld.CHECKBOX_GROUP:
      _expectCheckBoxGroupField(cff);
      break;
    case FormFieldTypeOld.RADIO_GROUP:
      _expectRadioGroupField(cff);
      break; 
    case FormFieldTypeOld.SELECT:
      _expectSelectField(cff);
      break;
  }
}

void _expectHeaderField(HeaderFormFieldOld cff){
  nHeaders++;
  _expectStaticSubType(cff);
  _expectIsWithoutValue(cff);
  _expectCustFormFieldToJson(cff);
}

void _expectCustFormFieldToJson(CustomFormFieldOld cff){
  final Map<String, dynamic> initialJson = _getCurrentInitialJson();
  _expectTextSingleValue(cff, initialJson);
  final Map<String, dynamic> currentFormFieldJson = cff.toJson();
  _transformCurrentFormFieldJson(currentFormFieldJson);
  // que primero sea igual al segundo. Expected: segundo
}

Map<String, dynamic> _getCurrentInitialJson(){
  final Map<String, dynamic> initialJson = initialJsonFormFields[numberOfElementsTraveled-1];
  _transformWildFormFIeldJson(initialJson);
  return initialJson;
}

void _transformWildFormFIeldJson(Map<String, dynamic> json){
  json.remove('access');
  json.remove('className');
}

void _transformCurrentFormFieldJson(Map<String, dynamic> formFieldJson){
  formFieldJson.removeWhere((key, value) => value == null);
}

void _expectParagraphField(ParagraphFormFieldOld cff){
  nParagraphs++;
  _expectStaticSubType(cff);
  _expectIsWithoutValue(cff);
  _expectCustFormFieldToJson(cff);
  //print('-*-*-*-*-*-*-*-*');
  //print('paragraf:');
  //print(cff.toJson());
}

void _expectTextField(UniqueLineTextOld cff){
  nTexts++;
  _expectRequiredAndName(cff);
  //_expectOldSubType(cff);
  _expectIsSingleValue(cff);
  _expectCustFormFieldToJson(cff);
}

void _expectTextAreaField(TextAreaOld cff){
  nTextAreas++;
  _expectRequiredAndName(cff);
  //_expectOldSubType(cff);
  _expectIsSingleValue(cff);
  _expectCustFormFieldToJson(cff);
}

void _expectNumberField(NumberFormFieldOld cff){
  nNumbers++;
  //_expectRequiredAndName(cff);
  _expectIsSingleValue(cff);
  _expectVariableFormField(cff);
  _expectCustFormFieldToJson(cff);
}

void _expectDateField(DateFieldOld cff){
  nDates++;
  _expectRequiredAndName(cff);
  _expectIsSingleValue(cff);
  _expectCustFormFieldToJson(cff);
}

void _expectTimeField(TimeFieldOld cff){
  nTimes++;
  _expectRequiredAndName(cff);
  _expectIsSingleValue(cff);
  _expectCustFormFieldToJson(cff);
}

void _expectCheckBoxGroupField(CheckBoxGroupOld cff){
  nCheckBoxGroups++;
  _expectRequiredAndName(cff);
  expect(cff.withSwitchType, isNotNull, reason: 'El toggle de un ckeckbox no deberia ser null');
  _expectLineal(cff);
  _expectIsMultiValue(cff);
  _expectMultiValueFieldToJson(cff);
}

void _expectMultiValueFieldToJson(MultiValueFormFieldOld cff){
  final Map<String, dynamic> initialJson = _getCurrentInitialJson();
  initialJson['label'] = null;
  final Map<String, dynamic> currentFormFieldJson = cff.toJson();
  currentFormFieldJson['label'] = null;
  _transformCurrentFormFieldJson(currentFormFieldJson);
  _transformMultiValueWildFormFieldJson(initialJson);
  //expect(currentFormFieldJson, initialJson);
}

void _transformMultiValueWildFormFieldJson(Map<String, dynamic> json){
  _transformWildFormFIeldJson(json);
  (json['values'].cast<Map<String, dynamic>>()).forEach(
    (Map<String, dynamic> v){
      if(v['selected'] == null)
        v['selected'] = false;
    }
  );
}

void _expectRadioGroupField(RadioGroupFormFieldOld cff){
  nRadioGroups++;
  _expectRequiredAndName(cff);
  _expectLineal(cff);
  _expectIsMultiValue(cff);
  _expectMultiValueFieldToJson(cff);
}

void _expectSelectField(SelectFormFieldOld cff){
  nSelects++;
  _expectRequiredAndName(cff);
  _expectIsMultiValue(cff);
  _expectMultiValueFieldToJson(cff);
}

void _expectRequiredAndName(VariableFormFieldOld cff){
  expect(cff.isRequired, isNotNull, reason: 'El isRequired del formfield actual no debería ser null');
  expect(cff.name, isNotNull, reason: 'El name del formfield actual no debería ser null');
}

void _expectStaticSubType(StaticFormFieldOld sff){
  expect(sff.subType, isNotNull, reason: 'El subtype del static formfield actual no debería ser null');
}

void _expectVariableFormField(VariableFormFieldOld vff){
  expect(vff.isRequired, isNotNull, reason: 'El isRequired de un variable form field no debe ser null');
  expect(vff.name, isNotNull, reason: 'El name del formfield actual no debería ser null');
}

void _expectLineal(MultiValueWithAlignmentOld cff){
  expect(cff.withVerticalAlignment, isNotNull, reason: 'El inLine del formField actual no deberia ser null');
}

void _expectIsMultiValue(MultiValueFormFieldOld mvff){
  expect(mvff.values, isNotNull, reason: 'Los values de un multivalue no pueden ser null');
  expect(mvff.values.length, isNot(0), reason: 'Los values de un multivalue deben ser al menos uno en cantidad');
}

void _expectIsSingleValue(CustomFormFieldOld cff){
  //expect(cff.value, isNotNull, reason: 'El value unitario de un singleValue no debe ser null');
  //expect(cff.values, isNull, reason: 'Los values de un singleValue deben ser null');
}

void _expectIsWithoutValue(StaticFormFieldOld cff){
  //expect(cff.values, isNull, reason: 'Los values de un static form field deben ser null'); 
  //expect(cff.value, isNull, reason: 'El value unitario de un static form field debe ser null');
}

void _expectTextSingleValue(CustomFormFieldOld cff, Map<String, dynamic> initialJson){
  if(cff is RawTextFormFieldOld){
    _processAndExpectDefaultValuesOfRawTextFormField(cff, initialJson);
  }if(cff is NumberFormFieldOld){
    _processAndExpectDefaultValuesOfNumber(cff, initialJson);
  }
}

void _processAndExpectDefaultValuesOfRawTextFormField(RawTextFormFieldOld rtff, Map<String, dynamic> initialJson){
  if(initialJson['maxlength'] == null){
    expect(rtff.maxLength, RawTextFormFieldOld.defaultMaxLength);
    rtff.maxLength = null;
  }
  if(rtff is TextAreaOld){
    expect(rtff.rows, TextAreaOld.defaultNumberOfRows);
    rtff.rows = null;
  }
}

void _processAndExpectDefaultValuesOfNumber(NumberFormFieldOld nff, Map<String, dynamic> initialJson){
  if(initialJson['step'] == null){
    expect(nff.step, NumberFormFieldOld.defaultStep);
    nff.step = null;
  }
}

void _printNotRequiredVariables(CustomFormFieldOld cff){
  if(cff.other != null)
    print('[[ With Other: ${cff.type}::${cff.label}::${cff.other} ]]');
  
}

_printNElementsOfEveryType(){
  print('°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°');
  print('nHeaders: $nHeaders');  
  print('nParagraphs: $nParagraphs');
  print('nTexts: $nTexts');
  print('nTextAreas: $nTextAreas');
  print('nNumbers: $nNumbers');
  print('nDates: $nDates');
  print('nTimes: $nTimes');
  print('nCheckBoxGroups: $nCheckBoxGroups');
  print('nRadioGroups: $nRadioGroups');
  print('nSelects: $nSelects');
  print('°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°');
  typesWithMax += ']';
  typesWithMaxLength += ']';
  typesWithInLine += ']';
  print('types with max: ');
  print(typesWithMax);
  print('types with maxLength: ');
  print(typesWithMaxLength);
  print('types with inLine: ');
  print(typesWithInLine);
}