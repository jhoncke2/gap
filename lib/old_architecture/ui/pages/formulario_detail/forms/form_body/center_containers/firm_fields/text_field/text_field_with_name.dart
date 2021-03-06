import 'package:flutter/material.dart';
import '../form_field_structure.dart';
import '../general_form_field_with_name.dart';
// ignore: must_be_immutable
class TextFieldWithName extends GeneralFormFieldWithName implements FormFieldStructure {
  
  final bool isAvaible;
  final TextInputType keyboardType;
  final bool obscureText;
  final String initialValue;
  final String helperText;
  final Function onTap;

  TextFieldWithName({
    Key key,
    this.isAvaible = true,
    @required String fieldName,
    @required Function onFieldChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.initialValue,
    this.helperText,
    this.onTap 
  }) : super(
    key: key,
    fieldName: fieldName,
    onFieldChanged: onFieldChanged,
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    createFieldBox();
    return super.build(context);
  }

  @override
  void createFieldBox(){
    this.fieldBox = TextFormField(
      enabled: this.isAvaible,
      initialValue: this.initialValue??'',
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        helperText: helperText,
        isDense: true,
        border: _createInputBorder(),
        enabledBorder: _createInputBorder()
      ),
      onChanged: this.onFieldChanged,
      onTap: onTap??(){},
    );
  }

  InputBorder _createInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(this.sizeUtils.xasisSobreYasis * 0.065),
      borderSide: BorderSide(
        color: Theme.of(this.context).primaryColor.withOpacity(0.525),
        width: 3.5
      )
    );
  }
}