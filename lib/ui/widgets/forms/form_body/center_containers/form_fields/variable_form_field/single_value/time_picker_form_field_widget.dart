import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
class TimePickerFormFieldWidget extends StatelessWidget {

  final TimeField timeFormField;
  TimePickerFormFieldWidget({Key key, @required this.timeFormField}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children:[
          Text(timeFormField.label),
          SizedBox(height: 10),
          CupertinoTimerPicker(
            onTimerDurationChanged: _onDurationChanged
          )
        ],
      ),
    );
  }

  void _onDurationChanged(Duration newValue){
    timeFormField.value = newValue;
  }
}