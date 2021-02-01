import 'package:flutter/material.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_field_structure.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_select/form_select_box.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/general_form_field_without_name.dart';
// ignore: must_be_immutable
class FormSelectWitouthName extends GeneralFormFieldWithoutName implements FormFieldStructure{
  final List<String> items;
  
  FormSelectWitouthName({
    Key key,
    @required this.items,
    @required Function onFieldChanged,
    double width
  }):super(
    key:key,
    onFieldChanged:onFieldChanged,
    width: width
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    createFieldBox();
    return super.build(context);
  }

  @override
  void createFieldBox() {
    this.fieldBox = FormSelectBox(items: items, onSelected: this.onFieldChanged);
  }
}