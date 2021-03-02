import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/select.dart';
class SelectFormFieldWidget extends StatelessWidget {
  final SelectFormField selectFormField;
  SelectFormFieldWidget({Key key, @required this.selectFormField}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(selectFormField.label),
          SizedBox(height: 10),
          _CustomSelect(selectFormField: selectFormField)
        ],
      ),
    );
  }
}

class _CustomSelect extends StatefulWidget {
  final SelectFormField selectFormField;
  _CustomSelect({Key key, @required this.selectFormField}) : super(key: key);

  @override
  __CustomSelectState createState() => __CustomSelectState();
}

class __CustomSelectState extends State<_CustomSelect> {

  String _currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        items: _createItems(),
        value: _currentSelectedValue,
        onChanged: _onChanged,
      ),
    );
  }

  void _onChanged(String newValue){
    widget.selectFormField.values.forEach((
      (v){
          _updateStateBySelection(v, newValue);
      }
    ));
  }

  void _updateStateBySelection(MultiFormFieldValue v, String newSelectedValue){
    setState(() {
      _currentSelectedValue = newSelectedValue;
      _decideIfSelectOrDisSelectValue(v, newSelectedValue);
    });
  }

  void _decideIfSelectOrDisSelectValue(MultiFormFieldValue v, String newValue){
    if(v.value == newValue)
      v.selected = true;
    else
      v.selected = false; 
  }

  List<DropdownMenuItem<String>> _createItems(){
    final List<MultiFormFieldValue> values = widget.selectFormField.values;
    return values.map<DropdownMenuItem<String>>(
      (v) => DropdownMenuItem<String>(
        child: Text(v.label),
        value: v.value,
      )
    ).toList();
  }
}