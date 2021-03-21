import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields/variable_form_field/single_value/text_form_field/single_text_form_field_widget.dart';
import './mock_app.dart';

final UniqueLineText uniqueLineTextFormFieldText = UniqueLineText.fromJson({
  'type':'text',
  'label':'text text',
  'subtype':'text',
  'maxlength':20,
  'placeholder':'parangaricutirimicuaro@gmail.com'
});
final UniqueLineText uniqueLineTextFormFieldEmail = UniqueLineText.fromJson({
  'type':'text',
  'label':'text email',
  'subtype':'email',
  'placeholder':'parangaricutirimicuaro@gmail.com'
});

final UniqueLineText uniqueLineTextFormFieldPassword = UniqueLineText.fromJson({
  'type':'text',
  'label':'text password',
  'subtype':'password',
  'placeholder':'parangaricutirimicuaro@gmail.com',
  'description':'description X2'
});

final UniqueLineText uniqueLineTextFormFieldTel = UniqueLineText.fromJson({
  'type':'text',
  'label':'text tel',
  'subtype':'tel',
  'placeholder':'123456789',
  
});

final UniqueLineText uniqueLineTextFormFieldColor = UniqueLineText.fromJson({
  'type':'text',
  'label':'text color',
  'subtype':'color',
  'description':'description X3'
});

WidgetTester _currentTester;

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Se testeará la creación de un ParagraphFormFieldWidget', (WidgetTester tester)async{
    await _testHeaderFormFieldWidgetCreationH1(tester);
    await _testSingleTextFormFieldWidgetCreationText(tester);
    await _testHeaderFormFieldWidgetCreationH6(tester);
  });
}

Future _testHeaderFormFieldWidgetCreationH1(WidgetTester tester)async{
  _currentTester = tester;
  SingleTextFormFieldWidget singleTextWidget = SingleTextFormFieldWidget(uniqueLineText: uniqueLineTextFormFieldText);
  final MockApp app = MockApp(singleTextWidget);
  await _currentTester.pumpWidget(app);
  _expectWidgetConfiguration(singleTextWidget);
  await _expectTextFieldInitialValue();
}

void _expectWidgetConfiguration(SingleTextFormFieldWidget singleTextWidget){
  final inputFinder = find.text(uniqueLineTextFormFieldText.label);
  expect(inputFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(singleTextWidget.keyboardType, TextInputType.text);
  expect(singleTextWidget.obscureText, false);
}

Future _expectTextFieldInitialValue()async{
  final textFieldFinder = find.byType(TextFormField);
  expect(textFieldFinder, findsOneWidget, reason: 'Debería haber un TextFormField');
  final widgetsIterator = textFieldFinder.allCandidates.iterator;
  TextFormField textField = _obtainFormFieldFormIterator(widgetsIterator);
  expect(textField.initialValue, uniqueLineTextFormFieldText.placeholder);

  String insertedText = 'parangaricutirimicuaro';
  await _currentTester.enterText(textFieldFinder, insertedText);
  expect(uniqueLineTextFormFieldText.uniqueValue, insertedText);
}

TextFormField _obtainFormFieldFormIterator(Iterator<Element> widgetsIterator){
  while(widgetsIterator.moveNext()){
    final current = widgetsIterator.current;
    if(current.widget.runtimeType == TextFormField)
      return current.widget;
  }
  return null;
}

Future _testSingleTextFormFieldWidgetCreationText(WidgetTester tester)async{
  SingleTextFormFieldWidget singleTextWidget = SingleTextFormFieldWidget(uniqueLineText: uniqueLineTextFormFieldEmail);
  final MockApp app = MockApp(singleTextWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(uniqueLineTextFormFieldEmail.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(singleTextWidget.keyboardType, TextInputType.emailAddress);
  expect(singleTextWidget.obscureText, false);
}

Future _testHeaderFormFieldWidgetCreationH6(WidgetTester tester)async{
  SingleTextFormFieldWidget singleTextWidget = SingleTextFormFieldWidget(uniqueLineText: uniqueLineTextFormFieldPassword);
  final MockApp app = MockApp(singleTextWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(uniqueLineTextFormFieldPassword.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(singleTextWidget.keyboardType, TextInputType.text);
  expect(singleTextWidget.obscureText, true);
}