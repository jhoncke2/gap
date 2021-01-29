import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_field.dart';
class FirstFirmerPerInfo extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  FirstFirmerPerInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomFormField(fieldName: 'Nombre de quien atiende', onFieldChanged: _onNombreChanged),
          CustomFormField(fieldName: 'Tipo de documento', onFieldChanged: _onTipoDocumentoChanged),
          CustomFormField(fieldName: 'Número de documento', onFieldChanged: _onNumDocumentoChanged)
        ],
      ),
    );
  }

  void _onNombreChanged(){

  }

  void _onTipoDocumentoChanged(){

  }

  void _onNumDocumentoChanged(){

  }
}