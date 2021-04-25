import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import '../enum_values.dart';

abstract class CustomFormField extends Equatable{
  final FormFieldType type;
  final String label;
  final bool other;

  CustomFormField({
    @required this.type,
    @required String label,
    @required this.other,
  }):
    this.label = label.replaceAll(RegExp(r'&nbsp;'), ' ')
  ;

  @override
  List<Object> get props => [type, label, other];
}

enum FormFieldType { HEADER, PARAGRAPH, SINGLE_TEXT, TEXT_AREA, NUMBER, DATE, TIME, CHECKBOX_GROUP, RADIO_GROUP, SELECT}

final typeValues = EnumValues({
  'header':FormFieldType.HEADER,
  'paragraph':FormFieldType.PARAGRAPH,
  'text':FormFieldType.SINGLE_TEXT,
  'textarea':FormFieldType.TEXT_AREA,
  'number':FormFieldType.NUMBER,
  'date':FormFieldType.DATE,
  'time':FormFieldType.TIME,
  'checkbox-group':FormFieldType.CHECKBOX_GROUP,
  'radio-group':FormFieldType.RADIO_GROUP,
  'select':FormFieldType.SELECT
});

class FormFieldSubType extends Enum<String>{
  const FormFieldSubType(String value) : super(value);

  static FormFieldSubType getSubTypeFromValue(String value, List<FormFieldSubType> subTypes){
    for(FormFieldSubType item in subTypes)
      if(item.value == value)
        return item;
    return null;
  }
}