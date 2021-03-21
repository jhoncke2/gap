import 'package:flutter/material.dart';
import '../form_field_structure.dart';
import '../general_form_field_without_name.dart';
import 'firm_select_box.dart';
// ignore: must_be_immutable
class FirmSelectWitouthName extends GeneralFormFieldWithoutName implements FormFieldStructure{
  final List<String> items;
  final String initialValue;
  
  FirmSelectWitouthName({
    Key key,
    @required this.items,
    @required Function onFieldChanged,
    @required this.initialValue,
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
    this.fieldBox = FirmSelectBox(items: items, onSelected: this.onFieldChanged, borderShape: this.borderShape, initialValue: this.initialValue);
  }
}