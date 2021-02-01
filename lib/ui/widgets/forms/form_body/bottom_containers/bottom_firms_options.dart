import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/ui/pages/formularios_page.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
// ignore: must_be_immutable
class BottomFirmsOptions extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormBloc _chosenFormBloc;
  Function _onPressed;
  BottomFirmsOptions();

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _createAddFirmButton(),
          _createFinishButton()
        ],
      ),
    );
  }

  void _initInitialConfiguration(BuildContext context){
    _context = context;
    _chosenFormBloc = BlocProvider.of<ChosenFormBloc>(_context);
  }

  Widget _createAddFirmButton(){
    _defineFinishOnPressed();
    return GeneralButton(
      text: 'Agregar Firma',
      onPressed: _onPressed,
      borderShape: BtnBorderShape.Circular,
      backgroundColor: Theme.of(_context).secondaryHeaderColor
    );
  }

  void _defineFinishOnPressed(){
    final bool puedeAvanzar = ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep();
    if(puedeAvanzar){
      _onPressed = _onAddNewFirm;
    }else{
      _onPressed = null;
    }
  }

  void _onAddNewFirm(){
    _chosenFormBloc.add(InitFirmsFillingOut());
  }

  Widget _createFinishButton(){
    return GeneralButton(
      text: 'Finalizar', 
      onPressed: _onFinish, 
      backgroundColor: Theme.of(_context).secondaryHeaderColor
    );
  }

  void _onFinish(){
    _chosenFormBloc.add(ResetChosenForm());
    //TODO: El service de enviar formulario
    Navigator.of(_context).pushReplacementNamed(FormulariosPage.route);
  }
}