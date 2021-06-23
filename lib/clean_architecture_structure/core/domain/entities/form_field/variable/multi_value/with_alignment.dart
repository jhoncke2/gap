import '../../custom_form_field.dart';
import 'multi_value_form_field.dart';

// ignore: must_be_immutable
class MultiValueWithAlignment extends MultiValueFormField{
  bool withVerticalAlignment;

  MultiValueWithAlignment({
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other,
    List<MultiFormFieldValue> values,
    bool multiple,
    this.withVerticalAlignment
  }):super(
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other
  );
  @override
  List<Object> get props => [...super.props, withVerticalAlignment];
}

// ignore: must_be_immutable
class CheckBoxGroup extends MultiValueWithAlignment{
  bool withSwitchType;
  
  CheckBoxGroup({
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other,
    List<MultiFormFieldValue> values,
    bool multiple,
    bool withVerticalAlignment
  }):super(
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other,
    withVerticalAlignment: withVerticalAlignment
  );
  @override
  List<Object> get props => [...super.props, withSwitchType];
}

// ignore: must_be_immutable
class RadioGroupFormField extends MultiValueWithAlignment{
  RadioGroupFormField({
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other,
    List<MultiFormFieldValue> values,
    bool multiple,
    bool withVerticalAlignment
  }):super(
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other,
    withVerticalAlignment: withVerticalAlignment
  );
}