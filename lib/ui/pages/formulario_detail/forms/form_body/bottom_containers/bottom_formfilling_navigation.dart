import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';
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
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _ChangeFormStepButton(chosenFormState: _chosenFormState),
            SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
            _createIndexField()
          ],
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _chosenFormState = BlocProvider.of<ChosenFormBloc>(_context).state;
  }

  Widget _createIndexField(){
    if([FormStep.OnForm, FormStep.Finished].contains( _chosenFormState.formStep )){
      return IndexPagination();
    }else{
      return Container(
        height: _sizeUtils.xasisSobreYasis * 0.05,
      );
    }
  } 
}


// ignore: must_be_immutable
class _ChangeFormStepButton extends StatelessWidget {

  final ChosenFormState chosenFormState;
  BuildContext _context;
  Function _onPressed;

  _ChangeFormStepButton({
    @required this.chosenFormState,
  });

  @override
  Widget build(BuildContext context){
    _initInitialConfiguration(context);
    _generateOnPressedFunction();
    return _createButtonByIndexState(context);
  }

  Widget _createButtonByIndexState(BuildContext context){
    final IndexState indexState = BlocProvider.of<IndexBloc>(context).state;
    if(chosenFormState.formStep == FormStep.Finished || indexState.currentIndexPage != indexState.nPages-1)
      return Container();
    else{
      return GeneralButton(
        backgroundColor: Theme.of(_context).secondaryHeaderColor,
        text: 'Siguiente',
        onPressed: _onPressed,
      );
    }
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext; 
  }

  void _generateOnPressedFunction(){
    //TODO: Implementar verificación de que todos los formularios estén diligenciados

    if(ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep()){
      _onPressed = _irASiguienteWidget;
    }else{
      _onPressed = null;
    }
  }

  void _irASiguienteWidget(){
    if(chosenFormState.formStep == FormStep.OnForm)
      PagesNavigationManager.initFirstFirmerFillingOut();
    else
      PagesNavigationManager.initFirstFirmerFirm();
  }
}