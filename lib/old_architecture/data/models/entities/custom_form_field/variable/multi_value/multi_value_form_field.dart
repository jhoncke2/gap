import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class MultiValueFormFieldOld extends VariableFormFieldOld{
  List<MultiFormFieldValueOld> values;
  //TODO: Averiguar qué significa (¿Significa que un select puede tener selección múltiple?)
  bool multiple;
  
  MultiValueFormFieldOld.fromJson(Map<String, dynamic> json): 
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

  bool _valueIsReallySelected(MultiFormFieldValueOld v) => (v.selected && v.value != null);
}

List<MultiFormFieldValueOld> _valuesFromJson(List<Map<String, dynamic>> jsonValues) => List<MultiFormFieldValueOld>.from(jsonValues.map((x) => MultiFormFieldValueOld.fromJson(x)));
List<Map<String, dynamic>> valuesToJson(List<MultiFormFieldValueOld> values)=> List<Map<String, dynamic>>.from(values.map((v) => v.toJson()));


class MultiFormFieldValueOld {
    MultiFormFieldValueOld({
        this.label,
        this.value,
        this.selected,
    });

    String label;
    String value;
    bool selected;

    factory MultiFormFieldValueOld.fromJson(Map<String, dynamic> json) => MultiFormFieldValueOld(
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


