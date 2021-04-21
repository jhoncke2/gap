import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields/static_form_fields/paragraph_form_field_widget.dart';
import 'mock_app.dart';

final ParagraphFormField paragraphFormFieldP = ParagraphFormField.fromJson({
  'type':'header',
  'label':'paragraph p',
  'subtype':'p',
});
final ParagraphFormField paragraphFormFieldAddress = ParagraphFormField.fromJson({
  'type':'header',
  'label':'paragraph address',
  'subtype':'address',
});

final ParagraphFormField paragraphFormFieldOutput = ParagraphFormField.fromJson({
  'type':'header',
  'label':'paragraph output',
  'subtype':'output',
});

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Se testeará la creación de un ParagraphFormFieldWidget', (WidgetTester tester)async{
    await _testHeaderFormFieldWidgetCreationH1(tester);
    await _testHeaderFormFieldWidgetCreationH6(tester);
  });
}

Future _testHeaderFormFieldWidgetCreationH1(WidgetTester tester)async{
  ParagraphFormFieldWidget paragraphWidget = ParagraphFormFieldWidget(paragraphFormField: paragraphFormFieldP);
  final MockApp app = MockApp(paragraphWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(paragraphFormFieldP.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(paragraphWidget.textStyle.fontWeight, FontWeight.normal, reason: 'El fontweight del titulo deberia ser bold');
  expect(paragraphWidget.textStyle.fontSize, app.sizeUtils.normalTextSize);
}

Future _testHeaderFormFieldWidgetCreationH6(WidgetTester tester)async{
  ParagraphFormFieldWidget paragraphWidget = ParagraphFormFieldWidget(paragraphFormField: paragraphFormFieldOutput);
  final MockApp app = MockApp(paragraphWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(paragraphFormFieldOutput.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(paragraphWidget.textStyle.fontWeight, FontWeight.normal, reason: 'El fontweight del titulo deberia ser bold');
  expect(paragraphWidget.textStyle.fontSize, app.sizeUtils.normalTextSize);
}