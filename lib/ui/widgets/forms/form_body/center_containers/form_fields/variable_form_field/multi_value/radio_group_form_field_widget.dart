import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/alignment_multi_option_list.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/variable_form_field_container.dart';
class RadiousGroupFormFieldWidget extends StatefulWidget {
  final RadioGroupFormField radioGroupFormField;

  RadiousGroupFormFieldWidget({Key key, @required this.radioGroupFormField}) : super(key: Key(radioGroupFormField.name));

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
          setState(() {
            _changeItemStateByNewSelected(value, newSelected); 
            
          });
        },
      ),
    );
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