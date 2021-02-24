part of 'entities.dart';
class CustomFormFields{
  List<CustomFormField> formFields;
  
  CustomFormFields(List<CustomFormField> formFields){
    this.formFields = formFields;
  }

  CustomFormFields.fromJson(List<Map<String, dynamic>> fields){
    this.formFields = fields.map<CustomFormField>(
      (Map<String, dynamic> field) => CustomFormField.fromJson(field)
    ).toList();
  }
  List<Map<String, dynamic>> toJson()=> formFields.map<Map<String, dynamic>>(
    (CustomFormField f)=>f.toJson()
  ).toList();
}

class CustomFormField{
  int id;
  String name;
  InputType type;
  bool isFilled;
  String value;

  CustomFormField({
    @required this.id, 
    @required this.name, 
    @required this.type
  }):
    this.isFilled = false
    ;

  CustomFormField.fromJson(Map<String, dynamic> json):
    this.id = json['id'],
    this.name = json['name'],
    this.isFilled = json['is_filled']??false,
    this.value = json['value']
  {
    _defineType(json['type']);
    
  }
  
  void _defineType(String type){
    switch(type){
      case 'input':
        this.type = InputType.TextField;
        break;
      case 'select':
        this.type = InputType.Select;
        break;
    }
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'name':name,
    'type':type.value,
    'is_filled':isFilled,
    'value':value
  };
}