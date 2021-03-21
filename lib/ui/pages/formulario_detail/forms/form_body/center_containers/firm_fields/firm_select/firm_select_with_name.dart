import 'package:flutter/material.dart';
import '../form_field_structure.dart';
import '../general_form_field_with_name.dart';
import 'firm_select_box.dart';
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