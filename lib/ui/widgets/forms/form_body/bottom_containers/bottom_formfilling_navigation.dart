import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/indexing/index_pagination.dart';
// ignore: must_be_immutable
class BottomFormFillingNavigation extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormState _chosenFormState;
  BottomFormFillingNavigation();

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      child: Column(
        children: [
          _ChangeFormStepButton(chosenFormState: _chosenFormState),
          _createIndexField()
        ],
      ),
    );
  }

  Widget _createIndexField(){
    if(_chosenFormState.formStep == FormStep.OnForm){
      return IndexPagination();
    }else{
      return Container(
        height: _sizeUtils.xasisSobreYasis * 0.05,
      );
    }
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _chosenFormState = BlocProvider.of<ChosenFormBloc>(_context).state;
  }
}

// ignore: must_be_immutable
class _ChangeFormStepButton extends StatelessWidget {
  FormulariosState _formsWidgetsState;
  final ChosenFormState chosenFormState;
  BuildContext _context;
  Function _onPressed;
  _ChangeFormStepButton({
    @required this.chosenFormState
  });

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    _generateOnPressedFunction();
    return GeneralButton(
      backgroundColor: Theme.of(_context).primaryColor,
      text: 'Siguiente',
      onPressed: _onPressed,
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _formsWidgetsState = BlocProvider.of<FormulariosBloc>(_context).state;
  }

  void _generateOnPressedFunction(){
    //TODO: Implementar verificación de que todos los formularios estén diligenciados
    if(true){
      _onPressed = _irASiguienteWidget;
    }else{
      _onPressed = null;
    }
  }

  void _irASiguienteWidget(){
    ChosenFormEvent initNewStepEvent;
    if(chosenFormState.formStep == FormStep.OnForm){
      initNewStepEvent = InitFirstFirmerFillingOut();
    }else{
      initNewStepEvent = InitFirstFirmerFirm();
    }
    _ejecutarEvento(initNewStepEvent);
  }

  void _ejecutarEvento(ChosenFormEvent event){
    final ChosenFormBloc cfBloc = BlocProvider.of<ChosenFormBloc>(_context);
    cfBloc.add(event);
  }
}