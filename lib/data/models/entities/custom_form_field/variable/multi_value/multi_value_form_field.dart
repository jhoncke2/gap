import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class MultiValueFormField extends VariableFormField{
  List<Value> values;
  MultiValueFormField.fromJson(Map<String, dynamic> json): 
    values = json["values"] == null ? null : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    super.fromJson(json)
    ;
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['values'] = values;
  }

}

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
        selected: json["selected"] == null ? null : json["selected"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "selected": selected == null ? null : selected,
    };
}


