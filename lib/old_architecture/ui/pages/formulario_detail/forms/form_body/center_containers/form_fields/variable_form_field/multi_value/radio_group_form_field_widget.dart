import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import '../variable_form_field_container.dart';
import 'alignment_multi_option_list.dart';
class RadiousGroupFormFieldWidget extends StatefulWidget {
  final RadioGroupFormField radioGroupFormField;
  final bool avaible;

  RadiousGroupFormFieldWidget({Key key, @required this.radioGroupFormField, this.avaible = true}) : super(key: Key(radioGroupFormField.name));

  @override
  _RadiousGroupFormFieldWidgetState createState() => _RadiousGroupFormFieldWidgetState();
}

class _RadiousGroupFormFieldWidgetState extends State<RadiousGroupFormFieldWidget> {
  final SizeUtils _sizeUtils = SizeUtils();

  @override
  Widget build(BuildContext context) {
    return VariableFormFieldContainer(
      title: widget.radioGroupFormField.label,
      child: AlignmentedMultiOptionList(
        withVerticalAlignment: widget.radioGroupFormField.withVerticalAlignment, 
        values: widget.radioGroupFormField.values, 
        onItemCreated: _onItemCreated
      ),
    );
  }

  Widget _onItemCreated(MultiFormFieldValue value, Function(Function) onSetState){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: _sizeUtils.xasisSobreYasis * 0.25,
      child: RadioListTile<String>(
        key: Key('${widget.radioGroupFormField.name}_${value.value}'),
        title: Text(value.label),
        groupValue: _getSelectedValueValue(),
        value: '${widget.radioGroupFormField.name}_${value.value}',
        selected: value.selected,
        activeColor: Colors.lightGreen[600],
        onChanged: (String newSelected){
          if(widget.avaible)
            _onChangedBeeingAvaible(value, newSelected);
        },
      ),
    );
  }
  
  void _onChangedBeeingAvaible(MultiFormFieldValue value, String newSelected){
    setState(() {
      _changeItemStateByNewSelected(value, newSelected); 
      PagesNavigationManager.updateFormFieldsPage();
    });
  }

  String _getSelectedValueValue(){
    final List<MultiFormFieldValue> selected = widget.radioGroupFormField.values.where((element) => element.selected).toList();
    if(selected.length > 0)
      return _getUniqueValue(selected[0].value);
    return ''; 
  }

  void _changeItemStateByNewSelected(MultiFormFieldValue value, String newSelected){
    _disSelectAll();
    if(_getUniqueValue(value.value) == newSelected)
      value.selected = true;  
  }

  String _getUniqueValue(String value){
    return '${widget.radioGroupFormField.name}_$value';
  }

  void _disSelectAll(){
    widget.radioGroupFormField.values.forEach((element) {
      element.selected = false;
    });
  }
}