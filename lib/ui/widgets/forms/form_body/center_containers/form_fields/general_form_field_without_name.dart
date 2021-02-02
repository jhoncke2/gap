import 'package:flutter/material.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/general_form_field.dart';

// ignore: must_be_immutable
class GeneralFormFieldWithoutName extends GeneralFormField{
  GeneralFormFieldWithoutName({
    Key key,
    @required Function onFieldChanged,
    double width
  }):super(
    key:key,
    onFieldChanged:onFieldChanged,
    borderShape: BtnBorderShape.Ellyptic,
    width: width
  );

  @override
  Widget build(BuildContext context) {
    _createHead();
    return super.build(context);
  }

  void _createHead(){
    this.fieldHead = Container();
  }
}