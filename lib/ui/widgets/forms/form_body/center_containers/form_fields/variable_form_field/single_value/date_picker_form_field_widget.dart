import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class DatePickerFormFieldWidget extends StatefulWidget {

  final DateField dateFormField;


  DatePickerFormFieldWidget({Key key, @required this.dateFormField}) : super(key: key);

  @override
  _DatePickerFormFieldWidgetState createState() => _DatePickerFormFieldWidgetState();
}

class _DatePickerFormFieldWidgetState extends State<DatePickerFormFieldWidget> {
  final SizeUtils _sizeUtils = SizeUtils();

  DateTime initialDate;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _defineInitialDate();
    return Container(
      child: Column(
        children: [
          Text(widget.dateFormField.label),
          SizedBox(height: 10),
          _createDatePickerButton(),
        ],
      )
    );
  }

  Widget _createDatePickerButton(){
    return MaterialButton(
      color: Theme.of(_context).secondaryHeaderColor.withOpacity(0.1),
      child: Text(
        widget.dateFormField.valueAsString??'Seleccionar fecha',
        textDirection: TextDirection.ltr,
      ),
      onPressed: _onSelectDatePressed,
    );
  }

  Future _onSelectDatePressed()async{
    _defineInitialDate();
    final DateTime newDate = await showDatePicker(
      context: _context, 
      initialDate: initialDate, 
      firstDate: DateTime(1930, 1, 1), 
      lastDate: DateTime(2035, 11, 11)
    );
    _onDateChanged(newDate);
  }

  Widget _createCalendarDatePicker(){
    return CalendarDatePicker(
      firstDate: DateTime(1930, 1, 1),
      lastDate: DateTime(2035, 11, 11),
      initialDate: initialDate,
      onDateChanged: _onDateChanged, 
    );
  }

  void _defineInitialDate(){
    initialDate = widget.dateFormField.value ?? widget.dateFormField.initialDate ?? DateTime.now();
  }

  void _onDateChanged(DateTime newDate){
    setState(() {
      widget.dateFormField.value = newDate;
    });
  }
}