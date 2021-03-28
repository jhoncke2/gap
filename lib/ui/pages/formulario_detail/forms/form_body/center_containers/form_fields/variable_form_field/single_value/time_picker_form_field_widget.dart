import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';

import '../variable_form_field_container.dart';
class TimePickerFormFieldWidget extends StatefulWidget {

  final TimeField timeFormField;

  TimePickerFormFieldWidget({Key key, @required this.timeFormField}) : super(key: Key(timeFormField.name));

  @override
  _TimePickerFormFieldWidgetState createState() => _TimePickerFormFieldWidgetState();
}

class _TimePickerFormFieldWidgetState extends State<TimePickerFormFieldWidget> {
  BuildContext _context;

  @override
  Widget build(BuildContext context){
    _context = context;
    return VariableFormFieldContainer(
      title: widget.timeFormField.label, 
      child: _createPickerButton(),
    );
  }

  Widget _createPickerButton(){
    return MaterialButton(
      child: Text(_defineButtonText()),
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(_context).primaryColor.withOpacity(0.2),
      shape: _createButtonShape(),
      elevation: 0,
      onPressed: _onPickDurationPressed,
    );
  }

  String _defineButtonText(){
    if(widget.timeFormField.value != null)
      return widget.timeFormField.valueAsString;
    else if(widget.timeFormField.placeholder != null)
      return widget.timeFormField.placeholder;
    return 'Seleccionar duración';
  }

  ShapeBorder _createButtonShape(){
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
      side: BorderSide(
        color: Theme.of(_context).primaryColor.withOpacity(0.4),
        width: 1.25
      )
    );
  }

  Future _onPickDurationPressed()async{
    final TimeOfDay time = await showTimePicker(
      context: _context, 
      initialTime: TimeOfDay(hour: 0, minute: 0)
    );
    _onDurationChanged(time);
  }

  void _onDurationChanged(TimeOfDay newValue){
    setState((){
      widget.timeFormField.value = newValue;
      PagesNavigationManager.updateFormFieldsPage();
    });
  }
}