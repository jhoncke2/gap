import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/number_form_field_widget.dart';
import './mock_app.dart';

NumberFormField numberWithDefaultValues; //= NumberFormField.fromJson({
//  'type':'number',
//  'label':'number 1',
//  'name':'number_1'
//});

final NumberFormField numberWithoutDefaultValues = NumberFormField.fromJson({
  'type':'number',
  'label':'number 2',
  'name':'number_2',
  'step':3,
  'max':20,
  'min':-10,
  'placeholder':'2'
});

WidgetTester _currentTester;

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Se testeará la creación de un ParagraphFormFieldWidget', (WidgetTester tester)async{
    //await _testNumberWithDefaultValues(tester);
    await _testNumberWithoutDefaultValues(tester);
  });
}

Future _testNumberWithDefaultValues(WidgetTester tester)async{
  _currentTester = tester;
  NumberFormFieldWidget singleTextWidget = NumberFormFieldWidget(number: numberWithDefaultValues);
  final MockApp app = MockApp(singleTextWidget);
  await _currentTester.pumpWidget(app);
  _expectWidgetName(singleTextWidget);
}

void _expectWidgetName(NumberFormFieldWidget numberWidget){
  final inputFinder = find.text(numberWithDefaultValues.label);
  expect(inputFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
}

Future _expectWidget1Functionality(WidgetTester tester)async{
  final textFieldFinder = find.byType(TextFormField);
  //expect(textFieldFinder, findsOneWidget, reason: 'Debería haber un TextFormField');
  _expectThereIsElement(textFieldFinder, TextFormField);
  String insertedNumber = '25';
  await _currentTester.enterText(textFieldFinder, insertedNumber);
  expect(int.parse(insertedNumber), numberWithDefaultValues.value);

  final Finder plusButtonFinder = find.byKey(Key('${numberWithDefaultValues.name}_plus'));
  final Finder subtractButtonFinder = find.byKey(Key('${numberWithDefaultValues.name}_subtract'));

  _expectThereIsElement(plusButtonFinder, 'plus_button');
  _expectThereIsElement(subtractButtonFinder, 'subtract_button');

  int initialValue = numberWithDefaultValues.value;
  for(int i = 1; i <= 20; i++){
    await _tapButton(tester, plusButtonFinder);
    expect(numberWithDefaultValues.value, initialValue + i );
  }
  initialValue = numberWithDefaultValues.value;
  for(int i = 1; i <= 20; i++){
    await _tapButton(tester, subtractButtonFinder);
    expect(numberWithDefaultValues.value, initialValue - i);
  }
}

void _expectThereIsElement(Finder elementFinder, dynamic classType){
  expect(elementFinder, findsOneWidget, reason: 'Debería haber encontrado un elemento $classType');
}

Future _tapButton(WidgetTester tester, Finder finder)async{
  await tester.tap(finder);
}

TextFormField _obtainFormFieldFormIterator(Iterator<Element> widgetsIterator){
  while(widgetsIterator.moveNext()){
    final current = widgetsIterator.current;
    if(current.widget.runtimeType == TextFormField)
      return current.widget;
  }
  return null;
}

Future _testNumberWithoutDefaultValues(WidgetTester tester)async{
  NumberFormFieldWidget numberWidget = NumberFormFieldWidget(number: numberWithoutDefaultValues);
  final MockApp app = MockApp(numberWidget);
  await tester.pumpWidget(app);
  await _expectWidget2Functionality(tester);
}

Future _expectWidget2Functionality(WidgetTester tester)async{
  //final textFieldFinder = find.byType(TextFormField);
  final textFieldFinder = find.byKey(Key('${numberWithoutDefaultValues.name}_textfield'));
  //expect(textFieldFinder, findsOneWidget, reason: 'Debería haber un TextFormField');
  _expectThereIsElement(textFieldFinder, TextFormField);

  final Finder plusButtonFinder = find.byKey(Key('${numberWithoutDefaultValues.name}_plus'));
  final Finder subtractButtonFinder = find.byKey(Key('${numberWithoutDefaultValues.name}_subtract'));

  _expectThereIsElement(plusButtonFinder, 'plus_button');
  _expectThereIsElement(subtractButtonFinder, 'subtract_button');

  final int step = numberWithoutDefaultValues.step;
  final int max = numberWithoutDefaultValues.max;
  final int min = numberWithoutDefaultValues.min;
  int initialValue = numberWithoutDefaultValues.value;

  int expectedWithoutLimitsValue;
  for(int i = 1; i <= 20; i++){
    await _tapButton(tester, plusButtonFinder);
    expectedWithoutLimitsValue = initialValue + i*step;
    if(initialValue + i*step < max){
      expect(numberWithoutDefaultValues.value, expectedWithoutLimitsValue);
    }
    expect(numberWithoutDefaultValues.value < max, true);
  }
}