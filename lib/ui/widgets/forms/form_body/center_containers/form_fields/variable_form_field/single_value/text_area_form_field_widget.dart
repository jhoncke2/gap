import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/variable_form_field_container.dart';
class TextAreaFormFieldWidget extends StatelessWidget{
  final TextArea textArea;

  TextAreaFormFieldWidget({this.textArea}):super(key: Key(textArea.name));

  @override
  Widget build(BuildContext context){
    return VariableFormFieldContainer(
      title: textArea.label, 
      child: _createTextBox()
    );
  }

  Widget _createTextBox(){
    return TextFormField(
      initialValue: textArea.placeholder??textArea.value??'',
      maxLines: textArea.rows,
      minLines: 1,
      maxLength: textArea.maxLength,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      onChanged: _onChanged,
    );
  }

  void _onChanged(String newValue){
    textArea.uniqueValue = newValue;
  }
}