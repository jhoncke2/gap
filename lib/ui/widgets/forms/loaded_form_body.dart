import 'package:flutter/material.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/models/entities/formulario.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/forms/form_inputs_fraction.dart';
import 'package:gap/ui/widgets/forms/form_inputs_index.dart';
import 'package:gap/ui/widgets/page_title.dart';

// ignore: must_be_immutable
class LoadedFormBody extends StatelessWidget{
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  final Formulario _formulario;
  BuildContext _context;

  LoadedFormBody({
    @required this.formsState
  }):
    _formulario = formsState.chosenForm
    ;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: _createGeneralPadding(),
        color: Colors.grey.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PageTitle(title: _formulario.name, underlined: false, centerText: true),
            FormInputsFraction(),
            _createNextButton(),
            FormInputsIndex()
          ],
        )
      ),
    );
  }

  EdgeInsets _createGeneralPadding(){
    return EdgeInsets.only(
      top: _sizeUtils.xasisSobreYasis * 0.025,
      bottom: _sizeUtils.xasisSobreYasis * 0.045,
      left: _sizeUtils.xasisSobreYasis * 0.045,
      right: _sizeUtils.xasisSobreYasis * 0.045
    );
  }

  Widget _createNextButton(){
    return GeneralButton(
      backgroundColor: Theme.of(_context).primaryColor,
      text: 'Siguiente',
      onPressed: _terminarForm,
    );
  }

  void _terminarForm(){
    //Enviar servicio de crear formulario respuesta (?)
  }
}