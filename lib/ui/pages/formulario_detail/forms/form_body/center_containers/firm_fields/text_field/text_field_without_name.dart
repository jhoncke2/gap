import 'package:flutter/material.dart';
import '../form_field_structure.dart';
import '../general_form_field_without_name.dart';

// ignore: must_be_immutable
class TextFieldWithoutName extends GeneralFormFieldWithoutName implements FormFieldStructure{
  final String initialValue;
  final TextInputType keyboardType;
  TextFieldWithoutName({
    Key key,
    @required Function onFieldChanged,
    @required ValueNotifier controller,
    double width,
    this.initialValue = '',
    this.keyboardType
  }): super(
    key: key, 
    onFieldChanged: onFieldChanged,
    width: width,
    controller: controller
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
      keyboardType: keyboardType ?? TextInputType.text,
      controller: this.controller,
      decoration: InputDecoration( 
        isDense: true,
        border: _createInputBorder(),
        enabledBorder: _createInputBorder()
      ),
      onChanged: this.onFieldChanged,
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