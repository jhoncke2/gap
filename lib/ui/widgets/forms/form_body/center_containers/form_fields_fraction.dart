import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_single_text/form_single_text_with_name.dart';
class FormInputsFraction extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  FormInputsFraction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputsItems = _createInputsItems();
    return SingleChildScrollView(
      child: Container(
        height: _sizeUtils.xasisSobreYasis * 0.65,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: inputsItems,
        ),
      ),
    );
  }

  List<Widget> _createInputsItems(){
    final List<Widget> inputsItems = [];
    for(int i = 0; i < 4; i++){
      inputsItems.add(
        FormSingleTextWithName(
          fieldName: 'Campo ${i+1}',
          onFieldChanged: _onFieldChanged,
        )
      );
    }
    return inputsItems;
  }

  void _onFieldChanged(String newValue){
    //TODO: Implementar cuando se haya conectado con servicios de forms del back
  }
}