import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/alignment_multi_option_list.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/variable_form_field_container.dart';
class CheckboxGroupFormFieldWidget extends StatefulWidget {
  
  final CheckBoxGroup checkBoxGroup;

  CheckboxGroupFormFieldWidget({@required this.checkBoxGroup}): super(key: Key('${checkBoxGroup.name}'));

  @override
  _CheckboxGroupFormFieldWidgetState createState() => _CheckboxGroupFormFieldWidgetState();
}

class _CheckboxGroupFormFieldWidgetState extends State<CheckboxGroupFormFieldWidget> {
  final SizeUtils _sizeUtils = SizeUtils();

  @override
  Widget build(BuildContext context) {
    return VariableFormFieldContainer(
      title: widget.checkBoxGroup.label,
      child: AlignmentedMultiOptionList(
        withVerticalAlignment: widget.checkBoxGroup.withVerticalAlignment,
        values: widget.checkBoxGroup.values,
        onItemCreated: _onItemCreated,
      ),
    );
  }

  Widget _onItemCreated(MultiFormFieldValue value, Function(Function) onSetState){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.25,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: CheckboxListTile(
        key: Key('${widget.checkBoxGroup.name}_checkboxtile_${value.value}'),
        title: Text(
          value.label,
          style: TextStyle(
            color: value.selected? Colors.redAccent[600] : Theme.of(context).primaryColor
          ),
        ), 
        value: value.selected,
        onChanged: (bool isSelected){
          setState((){
            _onItemSelected(value, isSelected);
          });
        }
      ),
    );
  }

  void _onItemSelected(MultiFormFieldValue value, bool isSelected){
    value.selected = isSelected;
  }
}