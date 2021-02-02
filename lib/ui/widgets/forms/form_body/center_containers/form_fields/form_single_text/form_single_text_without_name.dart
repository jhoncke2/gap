import 'package:flutter/material.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_field_structure.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/general_form_field_without_name.dart';

// ignore: must_be_immutable
class FormSingleTextWithoutName extends GeneralFormFieldWithoutName implements FormFieldStructure{
  final String initialValue;
  FormSingleTextWithoutName({
    Key key,
    @required Function onFieldChanged,
    @required ValueNotifier controller,
    double width,
    this.initialValue = ''
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