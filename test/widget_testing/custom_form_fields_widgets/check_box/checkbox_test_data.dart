import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';

final List<Map<String, dynamic>> unSelectedValues = [
  {
    'label':'v 1',
    'value':'v_1'
  },
  {
    'label':'v 2',
    'value':'v_2'
  },
  {
    'label':'v 3',
    'value':'v_3'
  }
];

final List<Map<String, dynamic>> anySelectedValues = [
  {
    'label':'v 1',
    'value':'v_1',
    'selected':true
  },
  {
    'label':'v 2',
    'value':'v_2'
  },
  {
    'label':'v 3',
    'value':'v_3',
    'selected':false
  },
  {
    'label':'v 3',
    'value':'v_3',
    'selected':true
  }
];

CheckBoxGroup unselectedCheckBox = CheckBoxGroup.fromJson({
  'type':'checkbox',
  'label':'check 1',
  'name':'check_1',
  'toggle':true,
  'other':false,
  'inline':false,
  'values':unSelectedValues
});

CheckBoxGroup checkBoxWithAnySelected = CheckBoxGroup.fromJson({
  'type':'checkbox',
  'label':'check 2',
  'name':'check_2',
  'toggle':true,
  'other':false,
  'inline':false,
  'values':unSelectedValues
});