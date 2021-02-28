import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/text_form_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/static_form_fields/paragraph_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/single_text_form_field_widget.dart';
import './mock_app.dart';

final UniqueLineText uniqueLineTextFormFieldText = UniqueLineText.fromJson({
  'type':'text',
  'label':'text text',
  'subtype':'text',
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

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Se testeará la creación de un ParagraphFormFieldWidget', (WidgetTester tester)async{
    await _testHeaderFormFieldWidgetCreationH1(tester);
    await _testHeaderFormFieldWidgetCreationH6(tester);
  });
}

Future _testHeaderFormFieldWidgetCreationH1(WidgetTester tester)async{
  SingleTextFormFieldWidget paragraphWidget = SingleTextFormFieldWidget(uniqueLineText: uniqueLineTextFormFieldText);
  final MockApp app = MockApp(paragraphWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(uniqueLineTextFormFieldText.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
}

Future _testHeaderFormFieldWidgetCreationH6(WidgetTester tester)async{
  SingleTextFormFieldWidget paragraphWidget = SingleTextFormFieldWidget(uniqueLineText: uniqueLineTextFormFieldEmail);
  final MockApp app = MockApp(paragraphWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(uniqueLineTextFormFieldEmail.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
}