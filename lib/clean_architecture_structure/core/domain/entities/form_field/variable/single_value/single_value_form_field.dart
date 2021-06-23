import '../../custom_form_field.dart';
import '../variable_form_field.dart';

// ignore: must_be_immutable
class SingleValueFormField extends VariableFormField{
  dynamic uniqueValue;
  String placeholder;

  SingleValueFormField({
    this.uniqueValue,
    this.placeholder,
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other   
  }):super(
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other
  );

  @override
  bool get isCompleted => ![null, ''].contains(uniqueValue);
  @override
  List<Object> get props => [...super.props, uniqueValue, placeholder];
}