import 'package:gap/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:test/test.dart';

import 'package:gap/data/models/entities/entities.dart';
import 'cocar_form_fields_data.dart';

List<CustomFormField> formFields;
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

void main(){
  group('Se testeará el .fromJson y se verificarán cualidades de los elementos de la lista.', (){
    _testFromJson();
    _testJsonElements();
  });
  
}

Future _testFromJson()async{
  test('Se testeará el .fromJson de una lista de customFormFields', ()async{
    await _tryFromJson();
  });
}

Future _tryFromJson()async{
  //final String dataAsString = await getDataAsString();
  final String dataAsString = getCocarDataAsString();
  formFields = customFormFieldsFromJsonString(dataAsString);
  expect(formFields, isNotNull, reason: 'Los formFields no deben ser null');
  expect(formFields.length, isNot(0), reason: 'La cantidad de custom form fields debe ser mayor a 0');
}

Future _testJsonElements()async{
  test('Se testeará el .fromJson de una lista de customFormFields', ()async{
    try{ 
      await _tryTestJsonElements();
    }catch(err){
      print('Número de elementos recorridos. $numberOfElementsTraveled');
      final CustomFormField errCustomFormField = formFields[numberOfElementsTraveled-1];
      print('Elemento con error: ');
      print(errCustomFormField.toJson().toString());
      throw err;
    }
  });
}

Future _tryTestJsonElements()async{
  for(CustomFormField cff in formFields)
    _expectCustomFormField(cff);
  _printNElementsOfEveryType();
}

void _expectCustomFormField(CustomFormField cff){
  numberOfElementsTraveled++;
  expect(cff, isNotNull, reason: 'El custom form field actual no debe ser null');
  expect(cff.label, isNotNull, reason: 'El label del field no debe ser null');
  //expect(cff.isRequired, isNotNull, reason: 'El isRequired del field no debe ser null');
  final FormFieldType fieldType = cff.type;
  expect(fieldType, isNotNull, reason: 'El type del form field no debe ser null');
  _expectByType(cff, fieldType);
  _printNotRequiredVariables(cff);
}

void _expectByType(CustomFormField cff, FormFieldType type){
  switch(type){
    case FormFieldType.HEADER:
      _expectHeaderField(cff);
      break;
    case FormFieldType.PARAGRAPH:
      _expectParagraphField(cff);
      break;
    case FormFieldType.SINGLE_TEXT:
      _expectTextField(cff);
      break;
    case FormFieldType.TEXT_AREA:
      _expectTextAreaField(cff);
      break;
    case FormFieldType.NUMBER:
      _expectNumberField(cff);
      break;
    case FormFieldType.DATE:
      _expectDateField(cff);
      break;
    case FormFieldType.TIME:
      _expectTimeField(cff);
      break;
    case FormFieldType.CHECKBOX_GROUP:
      _expectCheckBoxGroupField(cff);
      break;
    case FormFieldType.RADIO_GROUP:
      _expectRadioGroupField(cff);
      break; 
    case FormFieldType.SELECT:
      _expectSelectField(cff);
      break;
  }
}

void _expectHeaderField(StaticFormField cff){
  nHeaders++;
  _expectStaticSubType(cff);
  _expectIsWithoutValue(cff);
}

void _expectParagraphField(StaticFormField cff){
  nParagraphs++;
  _expectStaticSubType(cff);
  _expectIsWithoutValue(cff);
  print('-*-*-*-*-*-*-*-*');
  print('paragraf:');
  print(cff.toJson());
}

void _expectTextField(CustomFormField cff){
  nTexts++;
  _expectRequiredAndName(cff);
  _expectOldSubType(cff);
  _expectIsSingleValue(cff);
}

void _expectTextAreaField(CustomFormField cff){
  nTextAreas++;
  _expectRequiredAndName(cff);
  _expectOldSubType(cff);
  _expectIsSingleValue(cff);
}

void _expectNumberField(Number cff){
  nNumbers++;
  //_expectRequiredAndName(cff);
  _expectIsSingleValue(cff);
  _expectVariableFormField(cff);
}

void _expectDateField(CustomFormField cff){
  nDates++;
  _expectRequiredAndName(cff);
  _expectIsSingleValue(cff);
}

void _expectTimeField(CustomFormField cff){
  nTimes++;
  _expectRequiredAndName(cff);
  _expectIsSingleValue(cff);
}

void _expectCheckBoxGroupField(CustomFormField cff){
  nCheckBoxGroups++;
  _expectRequiredAndName(cff);
  expect(cff.toggle, isNotNull, reason: 'El toggle de un ckeckbox no deberia ser null');
  _expectLineal(cff);
  _expectIsMultiValue(cff);
}

void _expectRadioGroupField(CustomFormField cff){
  nRadioGroups++;
  _expectRequiredAndName(cff);
  _expectLineal(cff);
  _expectIsMultiValue(cff);
}

void _expectSelectField(CustomFormField cff){
  nSelects++;
  _expectRequiredAndName(cff);
  _expectIsMultiValue(cff);
}

void _expectRequiredAndName(CustomFormField cff){
  expect(cff.isRequired, isNotNull, reason: 'El isRequired del formfield actual no debería ser null');
  expect(cff.name, isNotNull, reason: 'El name del formfield actual no debería ser null');
}

void _expectStaticSubType(StaticFormField sff){
  expect(sff.subType, isNotNull, reason: 'El subtype del static formfield actual no debería ser null');
}

void _expectVariableFormField(VariableFormField vff){
  expect(vff.isRequired, isNotNull, reason: 'El isRequired de un variable form field no debe ser null');
  expect(vff.name, isNotNull, reason: 'El name del formfield actual no debería ser null');
}

void _expectOldSubType(CustomFormField cff){
  expect(cff.oldSubType, isNotNull, reason: 'El subtype del formfield actual no debería ser null');
}

void _expectLineal(CustomFormField cff){
  expect(cff.inline, isNotNull, reason: 'El inLine del formField actual no deberia ser null');
}

void _expectIsMultiValue(CustomFormField cff){
  expect(cff.values, isNotNull, reason: 'Los values de un multivalue no pueden ser null');
  expect(cff.values.length, isNot(0), reason: 'Los values de un multivalue deben ser al menos uno en cantidad');
  expect(cff.value, isNull, reason: 'El value unitario de un multivalue debe ser null');

}

void _expectIsSingleValue(CustomFormField cff){
  //expect(cff.value, isNotNull, reason: 'El value unitario de un singleValue no debe ser null');
  expect(cff.values, isNull, reason: 'Los values de un singleValue deben ser null');  
}

void _expectIsWithoutValue(CustomFormField cff){
  expect(cff.values, isNull, reason: 'Los values de un static form field deben ser null'); 
  expect(cff.value, isNull, reason: 'El value unitario de un static form field debe ser null');
}

void _printNotRequiredVariables(CustomFormField cff){
  if(cff.max != null || cff.min != null || cff.multiple != null){
    _printCffInformation(cff);
    String notRequiredVariables = '[';
    if(cff.max != null){
      notRequiredVariables += 'Max: ${cff.max};';
      typesWithMax += '${typeValues.reverse[cff.type]},';
    }
      
    if(cff.min != null)
      notRequiredVariables += 'Min: ${cff.min};';
    if(cff.multiple != null)
      notRequiredVariables += 'Multiple: ${cff.multiple}';
    notRequiredVariables += ']';
    print(notRequiredVariables);
  }
  if(cff.maxlength != null)
    typesWithMaxLength += '${typeValues.reverse[cff.type]},';
  if(cff.inline != null)
    typesWithInLine += '${cff.type}, ';
  if(cff.placeholder != null && [FormFieldType.CHECKBOX_GROUP, FormFieldType.RADIO_GROUP, FormFieldType.SELECT].contains(cff.type)){
    _printCffInformation(cff);
    print('is multiOption with placeholder');
    print('${cff.placeholder}');
  }
}

void _printCffInformation(CustomFormField cff){
  print('********************************');
  print(cff.label);
  print(cff.type);
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