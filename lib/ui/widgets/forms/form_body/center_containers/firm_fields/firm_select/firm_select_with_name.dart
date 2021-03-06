import 'package:flutter/material.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/firm_fields/form_field_structure.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/firm_fields/firm_select/firm_select_box.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/general_form_field_with_name.dart';
// ignore: must_be_immutable
class FirmSelectWithName extends GeneralFormFieldWithName implements FormFieldStructure{
  final List<String> items;
  final String initialValue;
  
  FirmSelectWithName({
    Key key,
    @required this.items,
    @required this.initialValue,
    String fieldName,
    Function onFieldChanged
  }):super(
    key:key,
    fieldName:fieldName,
    onFieldChanged:onFieldChanged
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    createFieldBox();
    return super.build(context);
  }

  @override
  void createFieldBox() {
    this.fieldBox = FirmSelectBox(items: this.items, initialValue: initialValue, onSelected: this.onFieldChanged, borderShape: this.borderShape);
  }
}