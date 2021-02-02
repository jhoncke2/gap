import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/ui/pages/formularios_page.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';

// ignore: must_be_immutable
class BottomFirmsOptions extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  Function _onAddFirmPressed;
  Function _onFinishPressed;

  BottomFirmsOptions();

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return BlocBuilder<FirmPaintBloc, FirmPaintState>(
      builder: (context, state) {
        _defineOnPressedButtonsFunctions();
        return Container(
          color: Colors.redAccent,
          height: _sizeUtils.xasisSobreYasis * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_createAddFirmButton(), _createFinishButton()],
          )
        );
      },
    );
  }

  void _initInitialConfiguration(BuildContext context) {
    _context = context;
  }

  void _defineOnPressedButtonsFunctions() {
    final bool btnsAreActive =
        ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep();
    if (btnsAreActive) {
      _onAddFirmPressed = _addNewFirm;
      _onFinishPressed = _finish;
    } else {
      _onAddFirmPressed = null;
      _onFinishPressed = null;
    }
  }

  Widget _createAddFirmButton() {
    return GeneralButton(
        text: 'Agregar Firma',
        onPressed: _onAddFirmPressed,
        borderShape: BtnBorderShape.Circular,
        backgroundColor: Theme.of(_context).secondaryHeaderColor);
  }

  void _addNewFirm() {
    ChosenFormManagerSingleton.chosenFormManager.addNewFirm();
  }

  Widget _createFinishButton() {
    return GeneralButton(
        text: 'Finalizar',
        onPressed: _onFinishPressed,
        backgroundColor: Theme.of(_context).secondaryHeaderColor);
  }

  void _finish() {
    ChosenFormManagerSingleton.chosenFormManager.finishFirms();
    //TODO: El service de enviar formulario
    Navigator.of(_context).pushReplacementNamed(FormulariosPage.route);
  }
}
