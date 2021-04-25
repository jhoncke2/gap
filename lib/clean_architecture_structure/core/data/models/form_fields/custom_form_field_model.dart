import 'package:gap/clean_architecture_structure/core/domain/entities/form_field/custom_form_field.dart';

abstract class CustomFormFieldModel extends CustomFormField{
  CustomFormFieldModel({
    String label,
    FormFieldType type,
    bool other
  }):super(
    label: label,
    type: type,
    other: other
  );

  factory CustomFormFieldModel.fromJson(Map<String, dynamic> json){

  }

  Map<String, dynamic> toJson()=>{
    'label':label,    
    'type':type,
    'other':other,    
  };
}


