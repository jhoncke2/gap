import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/alignment_multi_option_list.dart';
class CheckboxGroupFormFieldWidget extends StatelessWidget {
  
  final CheckBoxGroup checkBoxGroup;

  CheckboxGroupFormFieldWidget({Key key, @required this.checkBoxGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(checkBoxGroup.label),
          SizedBox(height: 10),
          AlignmentedMultiOptionList(
            withVerticalAlignment: checkBoxGroup.withVerticalAlignment,
            values: checkBoxGroup.values,
            onItemCreated: _onItemCreated,
          )
        ]
      ),
    );
  }

  Widget _onItemCreated(MultiFormFieldValue value, Function(Function) onSetState){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: CheckboxListTile(
        value: value.selected,
        title: Text(
          value.label
        ),
        onChanged: (bool isSelected){
          print(value);
          onSetState((){_onItemSelected(value, isSelected);});
        }
      ),
    );
  }

  void _onItemSelected(MultiFormFieldValue value, bool isSelected){
    value.selected = isSelected;
  }
}