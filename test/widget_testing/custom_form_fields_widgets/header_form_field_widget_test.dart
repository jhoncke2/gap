import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/static_form_fields/header_form_field_widget.dart';
import './mock_app.dart';



final HeaderFormField headerFormFieldH1 = HeaderFormField.fromJson({
  'type':'header',
  'label':'header h1',
  'subtype':'h1',
});
final HeaderFormField headerFormFieldH6 = HeaderFormField.fromJson({
  'type':'header',
  'label':'header h2',
  'subtype':'h6',
});

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Se testeará la creación de un HeaderFormFieldWidget', (WidgetTester tester)async{
    await _testHeaderFormFieldWidgetCreationH1(tester);
    await _testHeaderFormFieldWidgetCreationH6(tester);
  });
}

Future _testHeaderFormFieldWidgetCreationH1(WidgetTester tester)async{
  HeaderFormFieldWidget headerWidget = HeaderFormFieldWidget(headerFormField: headerFormFieldH1);
  final MockApp app = MockApp(headerWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(headerFormFieldH1.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(headerWidget.textStyle.fontWeight, FontWeight.bold, reason: 'El fontweight del titulo deberia ser bold');
  expect(headerWidget.textStyle.fontSize, app.sizeUtils.subtitleSize * headerWidget.h1FontSizePercentage);
}

Future _testHeaderFormFieldWidgetCreationH6(WidgetTester tester)async{
  HeaderFormFieldWidget headerWidget = HeaderFormFieldWidget(headerFormField: headerFormFieldH6);
  final MockApp app = MockApp(headerWidget);
  await tester.pumpWidget(app);
  final titleFinder = find.text(headerFormFieldH6.label);
  expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  expect(headerWidget.textStyle.fontWeight, FontWeight.w600, reason: 'El fontweight del titulo deberia ser bold');
  expect(headerWidget.textStyle.fontSize, app.sizeUtils.subtitleSize * headerWidget.h6FontSizePercentage);
}