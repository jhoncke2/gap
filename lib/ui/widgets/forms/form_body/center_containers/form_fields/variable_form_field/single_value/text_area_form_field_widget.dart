import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
class TextAreaFormFieldWidget extends StatelessWidget{
  final TextArea textArea;

  TextAreaFormFieldWidget({this.textArea});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      child: Column(
        children:[
          Text(textArea.label),
          SizedBox(height: 10),
          TextFormField(
            initialValue: textArea.placeholder??'',
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
          ),
        ],
      )
    );
  }

  void _onChanged(String newValue){
    textArea.uniqueValue = newValue;
  }
}