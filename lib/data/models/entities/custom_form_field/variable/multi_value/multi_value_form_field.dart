import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class MultiValueFormField extends VariableFormField{
  List<Value> values;
  //TODO: Averiguar qué significa
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

  bool _valueIsReallySelected(Value v) => (v.selected && v.value != null);
}

List<Value> _valuesFromJson(List<Map<String, dynamic>> jsonValues) => List<Value>.from(jsonValues.map((x) => Value.fromJson(x)));
List<Map<String, dynamic>> valuesToJson(List<Value> values)=> List<Map<String, dynamic>>.from(values.map((v) => v.toJson()));


class Value {
    Value({
        this.label,
        this.value,
        this.selected,
    });

    String label;
    String value;
    bool selected;

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        label: json["label"],
        value: json["value"],
        selected: json["selected"] == null ? false : json["selected"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "selected": selected,
    };
}


