import '../../custom_form_field.dart';
import 'multi_value_form_field.dart';

class SelectFormField extends MultiValueFormField{
  SelectFormField({
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other,
    List<MultiFormFieldValue> values,
    bool multiple
  }):super(
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other
  );
}