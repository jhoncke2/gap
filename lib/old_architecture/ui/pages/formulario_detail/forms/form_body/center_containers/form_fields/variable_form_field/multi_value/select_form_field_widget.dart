import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/select.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import '../variable_form_field_container.dart';

class SelectFormFieldWidget extends StatelessWidget {

  final SelectFormField selectFormField;
  final bool avaible;
  SelectFormFieldWidget({Key key, @required this.selectFormField, this.avaible = true}) : super(key: Key(selectFormField.name));

  @override
  Widget build(BuildContext context) {
    return VariableFormFieldContainer(
      title: selectFormField.label,
      child: _CustomSelect(selectFormField: selectFormField, avaible: this.avaible),
    );
  }
}

class _CustomSelect extends StatefulWidget {
  final SelectFormField selectFormField;
  final bool avaible;
  _CustomSelect({Key key, @required this.selectFormField, @required this.avaible}) : super(key: key);

  @override
  __CustomSelectState createState() => __CustomSelectState();
}

class __CustomSelectState extends State<_CustomSelect> {

  String _currentSelectedValue;

  @override
  void initState() {
    for(MultiFormFieldValue v in widget.selectFormField.values){
      if(v.selected){
        _currentSelectedValue = v.value;
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: _createMainContainerDecoration(),
      child: DropdownButton<String>(
        items: _createItems(),
        value: _currentSelectedValue,
        onChanged: (widget.avaible)? _onChanged : null,
      ),
    );
  }

  BoxDecoration _createMainContainerDecoration(){
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).primaryColor,
        width: 1.0
      ),
      borderRadius: BorderRadius.circular(25)
    );
  }

  void _onChanged(String newValue){
    if(widget.avaible)
      _onChangedBeeingAvaible(newValue);
  }

  void _onChangedBeeingAvaible(String newValue){
    widget.selectFormField.values.forEach((
      (v){
          _updateStateBySelection(v, newValue);
          PagesNavigationManager.updateFormFieldsPage();
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