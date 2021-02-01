import 'package:flutter/material.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_field_structure.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/general_form_field_with_name.dart';
// ignore: must_be_immutable
class FormSingleTextWithName extends GeneralFormFieldWithName implements FormFieldStructure {

  FormSingleTextWithName({
    Key key,
    @required String fieldName,
    @required Function onFieldChanged
  }) : super(
    key: key,
    fieldName: fieldName,
    onFieldChanged: onFieldChanged
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    createFieldBox();
    return super.build(context);
  }

  @override
  void createFieldBox(){
    this.fieldBox = TextField(
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