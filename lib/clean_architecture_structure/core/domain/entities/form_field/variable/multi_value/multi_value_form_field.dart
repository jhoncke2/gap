import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';

import '../../custom_form_field.dart';
import '../variable_form_field.dart';

// ignore: must_be_immutable
class MultiValueFormField extends VariableFormField{
  List<MultiFormFieldValue> values;
  bool multiple;
  
  MultiValueFormField({
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

  bool get isCompleted => values.where((value) => _valueIsReallySelected(value)).length > 0;
  bool _valueIsReallySelected(MultiFormFieldValue v) => (v.selected && v.value != null);

  @override
  List<Object> get props => [...super.props, values, multiple];
}

class MultiFormFieldValue {
  MultiFormFieldValue({
      this.label,
      this.value,
      this.selected,
  });

  String label;
  String value;
  bool selected;

  factory MultiFormFieldValue.fromJson(Map<String, dynamic> json) => MultiFormFieldValue(
      label: json["label"],
      value: json["value"],
      selected: json["selected"] ?? false,
  );

  Map<String, dynamic> toJson() => {
      "label": label,
      "value": value,
      "selected": selected,
  };
}


