import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class MultiValueFormField extends VariableFormField{
  List<MultiFormFieldValue> values;
  //TODO: Averiguar qué significa (¿Significa que un select puede tener selección múltiple?)
  bool multiple;
  
  MultiValueFormField.fromJson(Map<String, dynamic> json): 
    values = json["values"] == null ? null : _valuesFromJson(json['values'].cast<Map<String, dynamic>>()),
    multiple = json['multiple'],
    super.fromJson(json)
    ;
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['values'] = valuesToJson(values);
    json['multiple'] = multiple;
    return json;
  }

  bool get isCompleted => values.where((value) => _valueIsReallySelected(value)).length > 0;

  bool _valueIsReallySelected(MultiFormFieldValue v) => (v.selected && v.value != null);
}

List<MultiFormFieldValue> _valuesFromJson(List<Map<String, dynamic>> jsonValues) => List<MultiFormFieldValue>.from(jsonValues.map((x) => MultiFormFieldValue.fromJson(x)));
List<Map<String, dynamic>> valuesToJson(List<MultiFormFieldValue> values)=> List<Map<String, dynamic>>.from(values.map((v) => v.toJson()));


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


