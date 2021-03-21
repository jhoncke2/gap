import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/select.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
import '../variable_form_field_container.dart';

class SelectFormFieldWidget extends StatelessWidget {
  final SelectFormField selectFormField;
  SelectFormFieldWidget({Key key, @required this.selectFormField}) : super(key: Key(selectFormField.name));

  @override
  Widget build(BuildContext context) {
    return VariableFormFieldContainer(
      title: selectFormField.label,
      child: _CustomSelect(selectFormField: selectFormField),
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

  final SizeUtils _sizeUtils = SizeUtils();
  String _currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: _createMainContainerDecoration(),
      child: DropdownButton<String>(
        items: _createItems(),
        value: _currentSelectedValue,
        onChanged: _onChanged,
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