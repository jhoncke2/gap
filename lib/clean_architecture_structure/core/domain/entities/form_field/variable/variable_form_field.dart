import 'package:meta/meta.dart';
import '../custom_form_field.dart';

abstract class VariableFormField extends CustomFormField{
  final String name;
  final bool isRequired;
  final String description;

  VariableFormField({
    @required this.name, 
    @required this.isRequired, 
    @required this.description,
    @required FormFieldType type,  
    @required String label,  
    @required bool other
  }):super(
    type: type,    
    label: label,    
    other: other      
  );

  bool get isCompleted;

  @override
  List<Object> get props => [...super.props, name, isRequired, description];
}