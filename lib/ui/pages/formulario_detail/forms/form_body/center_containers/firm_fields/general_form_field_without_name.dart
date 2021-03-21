import 'package:flutter/material.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields/general_form_field.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';

// ignore: must_be_immutable
class GeneralFormFieldWithoutName extends GeneralFormField{
  GeneralFormFieldWithoutName({
    Key key,
    @required Function onFieldChanged,
    double width,
    ValueNotifier controller
  }):super(
    key:key,
    onFieldChanged:onFieldChanged,
    borderShape: BtnBorderShape.Ellyptic,
    width: width,
    controller: controller
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