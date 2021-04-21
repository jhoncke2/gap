import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/checkbox_group_form_field_widget.dart';
import '../mock_app.dart';
import 'checkbox_test_data.dart';
import 'mock_check_box.dart';

WidgetTester _currentTester;

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group('se testeará crear checkboxgroup widget', (){
    testWidgets('Se testeará la creación de un CheckBoxGroupFormField deseleccionado', (WidgetTester tester)async{
      await _testCheckBoxWithoutInitialData(tester); 
    });
    testWidgets('Se testeará la creación de un CheckBoxGroupFormField con algunos seleccionados', (WidgetTester tester)async{
      //await _testCheckBoxWithInitialData(tester);
    });
  });
}

Future _testCheckBoxWithoutInitialData(WidgetTester tester)async{
  _currentTester = tester;
  CheckboxGroupFormFieldWidget numberWidget = MockCheckBoxGroupFormFieldWidget(checkBoxGroup: unselectedCheckBox);
  final MockApp app = MockApp(numberWidget);
  await _currentTester.pumpWidget(app);
  _expectWidgetName(unselectedCheckBox);
  _expectUnselectedWidgetFunctionality(tester);
}

void _expectWidgetName(CustomFormField formField){
  final inputFinder = find.text(formField.label);
  expect(inputFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
}

Future _expectUnselectedWidgetFunctionality(WidgetTester tester)async{
  final cbListTilesFinder = find.byType(CheckboxListTile);
  expect(cbListTilesFinder, findsWidgets);

  int expectedNCheckBoxListTiles = unselectedCheckBox.values.length;
  List<CheckboxListTile> cbListTiles = getCheckBoxListTileWidgets(cbListTilesFinder);
  expect(cbListTiles.length, expectedNCheckBoxListTiles);
  _expectTappingSequence(cbListTilesFinder, expectedNCheckBoxListTiles, tester, unselectedCheckBox);
}

Future _expectTappingSequence(Finder cbListTilesFinder, int nItems, WidgetTester tester, CheckBoxGroup formField)async{
  bool expectedCheckValue = true;
  for(int j = 0; j < nItems; j++){
    print(formField.values[j].selected);
    await tester.tap(cbListTilesFinder.at(j));
    print(formField.values);
    expect(formField.values[j].selected, expectedCheckValue);
  }

}

List<CheckboxListTile> getCheckBoxListTileWidgets(Finder cbListTilesFinder){
  return cbListTilesFinder.allCandidates.where((element) => element.widget is CheckboxListTile).toList().cast<CheckboxListTile>();
}

void _expectThereIsElement(Finder elementFinder, dynamic classType){
  expect(elementFinder, findsOneWidget, reason: 'Debería haber encontrado un elemento $classType');
}