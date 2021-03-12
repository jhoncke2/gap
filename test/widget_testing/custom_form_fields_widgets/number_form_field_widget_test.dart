import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/text_form_field/number_form_field_widget.dart';
import './mock_app.dart';

NumberFormField numberWithDefaultValues = NumberFormField.fromJson({
  'type':'number',
  'label':'number 1',
  'name':'number_1'
});

final NumberFormField numberWithoutDefaultValues = NumberFormField.fromJson({
  'type':'number',
  'label':'number 2',
  'name':'number_2',
  'step':3,
  'max':20,
  'min':-11,
  'placeholder':'2'
});

WidgetTester _currentTester;

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('se testeará crear number widget', (){
    testWidgets('Se testeará la creación de un NumberFormFieldWidget sin valores iniciales', (WidgetTester tester)async{
      await _testNumberWithDefaultValues(tester); 
    });
    testWidgets('Se testeará la creación de un NumberFormFieldWidget con valores iniciales', (WidgetTester tester)async{
      await _testNumberWithoutDefaultValues(tester);
    });
  });
}

Future _testNumberWithDefaultValues(WidgetTester tester)async{
  _currentTester = tester;
  NumberFormFieldWidget numberWidget = NumberFormFieldWidget(number: numberWithDefaultValues);
  final MockApp app = MockApp(numberWidget);
  await _currentTester.pumpWidget(app);
  _expectWidgetName(numberWithDefaultValues);
  _expectWidget1Functionality(tester);
}

void _expectWidgetName(NumberFormField formField){
  final inputFinder = find.text(formField.label);
  expect(inputFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
}

Future _expectWidget1Functionality(WidgetTester tester)async{
  final textFieldFinder = find.byKey(Key('${numberWithDefaultValues.name}_textfield'));
  _expectThereIsElement(textFieldFinder, TextFormField);
  await _expectSingleInsertion(25, textFieldFinder);

  final Finder plusButtonFinder = find.byKey(Key('${numberWithDefaultValues.name}_plus'));
  final Finder subtractButtonFinder = find.byKey(Key('${numberWithDefaultValues.name}_subtract'));
  _expectThereIsElement(plusButtonFinder, 'plus_button');
  _expectThereIsElement(subtractButtonFinder, 'subtract_button');

  await _expectPlusButtonTapSuccession(20, numberWithDefaultValues, tester, plusButtonFinder);
  await _expectSubtractButtonTapSuccession(20, numberWithDefaultValues, tester, subtractButtonFinder);
}

void _expectThereIsElement(Finder elementFinder, dynamic classType){
  expect(elementFinder, findsOneWidget, reason: 'Debería haber encontrado un elemento $classType');
}

Future _expectSingleInsertion(int insertedNumber, Finder textFieldFinder)async{
  String stringInsertedNumber = insertedNumber.toString();
  await _currentTester.enterText(textFieldFinder, stringInsertedNumber);
  expect(insertedNumber, numberWithDefaultValues.value);
}

Future _expectPlusButtonTapSuccession(int nTaps, NumberFormField formField, WidgetTester tester, Finder plusButtonFinder, [int initVal])async{
  int initialValue = initVal ?? formField.value;
  for(int i = 1; i <= nTaps; i++){
    await _tapButton(tester, plusButtonFinder);
    expect(formField.value, initialValue + i*formField.step );
  }
}

Future _tapButton(WidgetTester tester, Finder finder)async{
  await tester.tap(finder);
}

Future _expectSubtractButtonTapSuccession(int nTaps, NumberFormField formField, WidgetTester tester, Finder subtractButtonFinder)async{
  int initialValue = formField.value;
  for(int i = 1; i <= nTaps; i++){
    await _tapButton(tester, subtractButtonFinder);
    expect(formField.value, initialValue - i*formField.step);
  }
}

Future _testNumberWithoutDefaultValues(WidgetTester tester)async{
  NumberFormFieldWidget numberWidget = NumberFormFieldWidget(number: numberWithoutDefaultValues);
  final MockApp app = MockApp(numberWidget);
  await tester.pumpWidget(app);
  _expectWidgetName(numberWithoutDefaultValues);
  await _expectWidget2Functionality(tester, numberWidget);
}

Future _expectWidget2Functionality(WidgetTester tester, NumberFormFieldWidget numberWidget)async{
  final textFieldFinder = find.byKey(Key('${numberWithoutDefaultValues.name}_textfield'));
  _expectThereIsElement(textFieldFinder, TextFormField);

  final Finder plusButtonFinder = find.byKey(Key('${numberWithoutDefaultValues.name}_plus'));
  final Finder subtractButtonFinder = find.byKey(Key('${numberWithoutDefaultValues.name}_subtract'));
  _expectThereIsElement(plusButtonFinder, 'plus_button');
  _expectThereIsElement(subtractButtonFinder, 'subtract_button');

  final int max = numberWithoutDefaultValues.max;
  await _expectIcreasingValueToMax(tester, plusButtonFinder, max);
  final int min = numberWithoutDefaultValues.min;
  await _expectDecreasingValueToMin(tester, subtractButtonFinder, min);
}

Future _expectIcreasingValueToMax(WidgetTester tester, Finder plusButtonFinder, int max)async{
  await _expectPlusButtonTapSuccession(6, numberWithoutDefaultValues, tester, plusButtonFinder);
  for(int i = 0; i < 10; i++){
    await _tapButton(tester, plusButtonFinder);
    expect(numberWithoutDefaultValues.value, max);
  }
}

Future _expectDecreasingValueToMin(WidgetTester tester, Finder subtractButtonFinder, int min)async{
  await _expectSubtractButtonTapSuccession(10, numberWithoutDefaultValues, tester, subtractButtonFinder);
  for(int i = 0; i < 10; i++){
    print(numberWithoutDefaultValues.value);
    await _tapButton(tester, subtractButtonFinder);
    expect(numberWithoutDefaultValues.value, min);
  }
  
}