import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/old_architecture/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/widgets/buttons/general_button.dart';

// ignore: must_be_immutable
class BottomFirmsOptions extends StatelessWidget {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _createAddFirmButton(), 
              _createFinishButton()
            ],
          )
        );
      },
    );
  }

  void _initInitialConfiguration(BuildContext context) {
    _context = context;
  }

  void _defineOnPressedButtonsFunctions() {
    final bool btnsAreActive = ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep();
    if (btnsAreActive) {
      _onAddFirmPressed = _addNewFirm;
      _onFinishPressed = _finish;
    } else {
      _onAddFirmPressed = null;
      _onFinishPressed = null;
    }
  }

  Future<void> _addNewFirm()async{
    //await ChosenFormManagerSingleton.chosenFormManager.addFirmToFirmer();
    //ChosenFormManagerSingleton.chosenFormManager.addNewFirm();
    await PagesNavigationManager.addFirmer();
  }

  Future<void> _finish()async{
    await PagesNavigationManager.endFormFirmers();
  }

  Widget _createAddFirmButton() {
    return GeneralButton(
        text: 'Agregar Firma',
        onPressed: _onAddFirmPressed,
        borderShape: BtnBorderShape.Circular,
        backgroundColor: Theme.of(_context).secondaryHeaderColor);
  }

  Widget _createFinishButton() {
    return GeneralButton(
      text: 'Finalizar',
      onPressed: _onFinishPressed,
      backgroundColor: Theme.of(_context).secondaryHeaderColor
    );
  }
}
