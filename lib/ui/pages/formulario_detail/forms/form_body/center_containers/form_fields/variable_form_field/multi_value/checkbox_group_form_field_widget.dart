import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
import '../variable_form_field_container.dart';
import 'alignment_multi_option_list.dart';
class CheckboxGroupFormFieldWidget extends StatefulWidget {
  
  final CheckBoxGroup checkBoxGroup;
  final bool avaible;

  CheckboxGroupFormFieldWidget({@required this.checkBoxGroup, this.avaible = true}): super(key: Key('${checkBoxGroup.name}'));

  @override
  _CheckboxGroupFormFieldWidgetState createState() => _CheckboxGroupFormFieldWidgetState();

  @protected
  void updateFormFieldsPage(){
    PagesNavigationManager.updateFormFieldsPage();
  }
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
          if(widget.avaible)
            _onSelectBeeingAvaible(value, isSelected);
        }
      ),
    );
  }

  void _onSelectBeeingAvaible(MultiFormFieldValue value, bool isSelected){
    setState((){
      _onItemSelected(value, isSelected);
      widget.updateFormFieldsPage();
    });
  }

  void _onItemSelected(MultiFormFieldValue value, bool isSelected){
    value.selected = isSelected;
  }
}