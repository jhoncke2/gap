import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';

import 'mock_app.dart';

final TextAreaOld textArea1 = TextAreaOld.fromJson({
  'type':'textarea',
  'label':'text area x',
  'rows': 4,
});

final TextAreaOld textArea2 = TextAreaOld.fromJson({
  'type':'textarea',
  'label':'text area x',
  'maxlength': 23,
});

/*
void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Se testeará la creación de un ParagraphFormFieldWidget', (WidgetTester tester)async{
    await _testHeaderFormFieldWidgetCreationH1(tester);

  });
}
*/

Future _testHeaderFormFieldWidgetCreationH1(WidgetTester tester)async{  
  //TextAreaFormFieldWidget singleTextWidget = TextAreaFormFieldWidget(textArea: textArea1);
  //final MockApp app = MockApp(singleTextWidget);
  //await tester.pumpWidget(app);
  //final titleFinder = find.text(textArea1.label);
  //expect(titleFinder, findsOneWidget, reason: 'Debe haber un widget text con el texto introducido');
  //expect(singleTextWidget.keyboardType, TextInputType.text);
  //expect(singleTextWidget.obscureText, false);
}