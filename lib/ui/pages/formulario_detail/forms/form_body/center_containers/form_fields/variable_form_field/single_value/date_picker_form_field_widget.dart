import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';

import '../variable_form_field_container.dart';
// ignore: must_be_immutable
class DatePickerFormFieldWidget extends StatefulWidget {

  final DateField dateFormField;


  DatePickerFormFieldWidget({Key key, @required this.dateFormField}) : super(key: Key(dateFormField.name));

  @override
  _DatePickerFormFieldWidgetState createState() => _DatePickerFormFieldWidgetState();
}

class _DatePickerFormFieldWidgetState extends State<DatePickerFormFieldWidget> {

  DateTime pickerInitialDate;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _definePickerInitialDate();
    return VariableFormFieldContainer(
      title: widget.dateFormField.label,
      child: _createDatePickerButton(),
    );
  }

  Widget _createDatePickerButton(){
    return MaterialButton(
      color: Theme.of(_context).primaryColor.withOpacity(0.2),
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 20),
      shape: _createButtonShape(),
      child: Text(
        widget.dateFormField.valueAsString??'Seleccionar fecha',
        textDirection: TextDirection.ltr,
      ),
      onPressed: _onSelectDatePressed,
    );
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

  Future _onSelectDatePressed()async{
    _definePickerInitialDate();
    final DateTime newDate = await showDatePicker(
      context: _context, 
      initialDate: pickerInitialDate, 
      firstDate: DateTime(1930, 1, 1), 
      lastDate: DateTime(2035, 11, 11)
    );
    _onDateChanged(newDate);
  }

  void _definePickerInitialDate(){
    pickerInitialDate = widget.dateFormField.value ?? widget.dateFormField.initialDate ?? DateTime.now();
  }

  void _onDateChanged(DateTime newDate){
    setState(() {
      widget.dateFormField.value = newDate;
      PagesNavigationManager.updateFormFieldsPage();
    });
  }
}