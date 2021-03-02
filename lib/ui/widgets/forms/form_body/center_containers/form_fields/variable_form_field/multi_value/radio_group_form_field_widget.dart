import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/alignment_multi_option_list.dart';
class RadiousGroupFormFieldWidget extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final RadioGroupFormField radioGroupFormField;

  RadiousGroupFormFieldWidget({Key key, @required this.radioGroupFormField}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(radioGroupFormField.label),
          SizedBox(height: 10),
          AlignmentedMultiOptionList(
            withVerticalAlignment: radioGroupFormField.withVerticalAlignment, 
            values: radioGroupFormField.values, 
            onItemCreated: _onItemCreated
          )
        ],
      ),
    );
  }

  Widget _onItemCreated(MultiFormFieldValue value, Function(Function) onSetState){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: _sizeUtils.xasisSobreYasis * 0.25,
      child: RadioListTile<String>(
        title: Text(value.label),
        groupValue: radioGroupFormField.name,
        value: value.value,
        onChanged: (String newSelected){
          onSetState((){
            _changeItemStateByNewSelected(value, newSelected);
          });
        },
      ),
    );
  }
  
  void _changeItemStateByNewSelected(MultiFormFieldValue value, String newSelected){
    if(value.value == newSelected)
      value.selected = true;
    else
      value.selected = false;    
  }
}