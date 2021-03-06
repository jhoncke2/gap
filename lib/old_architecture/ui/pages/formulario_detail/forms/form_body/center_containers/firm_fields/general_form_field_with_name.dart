import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields/general_form_field.dart';

// ignore: must_be_immutable

class GeneralFormFieldWithName extends GeneralFormField{
  final String fieldName;
  GeneralFormFieldWithName({
    Key key,
    @required this.fieldName,
    @required Function onFieldChanged,
    ValueNotifier controller
  }):super(
    key:key,
    onFieldChanged:onFieldChanged,
    controller: controller
  );

  @override
  Widget build(BuildContext context) {
    _createHead();
    return super.build(context);
  }

  void _createHead(){
    this.fieldHead = Text(
      this.fieldName,
      style: TextStyle(
        color: Theme.of(this.context).primaryColor,
        fontSize: this.sizeUtils.subtitleSize
      ),
    );
  }
}
