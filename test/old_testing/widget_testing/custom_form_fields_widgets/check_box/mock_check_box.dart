import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/checkbox_group_form_field_widget.dart';

// ignore: must_be_immutable
class MockCheckBoxGroupFormFieldWidget extends CheckboxGroupFormFieldWidget{

  MockCheckBoxGroupFormFieldWidget({CheckBoxGroupOld checkBoxGroup}):super(checkBoxGroup: checkBoxGroup);

  @override
  void updateFormFieldsPage(){}
}