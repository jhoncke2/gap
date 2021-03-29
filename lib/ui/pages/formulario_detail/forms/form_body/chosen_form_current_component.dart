import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/ui/widgets/progress_indicator.dart';
import 'bottom_containers/bottom_formfilling_navigation.dart';
import 'center_containers/form_fields_fraction.dart';

// ignore: must_be_immutable
class ChosenFormCurrentComponent extends StatelessWidget {

  BuildContext _context;
  ChosenFormState _chosenFormState;
  Widget _bottomComponents;
  MainAxisAlignment columnMainAxisAlignment;
  double centerComponentsHeightPercent;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Expanded(
      child: BlocBuilder<ChosenFormBloc, ChosenFormState>(
        builder: (context, chosenFormState) {
          _chosenFormState = chosenFormState;
          _elegirComponentsSegunBlocsStates(context);
          return Container(
            child: Column(
              mainAxisAlignment: columnMainAxisAlignment,
              children: [
                _createCenterComponents(),
                //SizedBox(height: _sizeUtils.giantSizedBoxHeight),
                _bottomComponents
              ],
            ),
            padding: EdgeInsets.only(top: 25),
          );
        },
      ),
    );
  }

  void _elegirComponentsSegunBlocsStates(BuildContext context){
    _elegirComponentsSegunFormState();
    final bool keyboardIsActive = BlocProvider.of<KeyboardListenerBloc>(context).state.isActive;
    _defineColumnComponentsConfigByKeyboardState(keyboardIsActive);
  }

  void _elegirComponentsSegunFormState() {
    if(_chosenFormState.formStep == FormStep.OnForm) {
      _bottomComponents = BottomFormFillingNavigation();
    }else{
      _bottomComponents = Container();
    }
  }

  void _defineColumnComponentsConfigByKeyboardState(bool keyBoardIsActive){
    final IndexState indexState = BlocProvider.of<IndexBloc>(_context).state;
    double extraContainerHeightPercent = (indexState.currentIndexPage == indexState.nPages-1)? -0.015   : 0.075;
    if(keyBoardIsActive){
      columnMainAxisAlignment = MainAxisAlignment.start;
      centerComponentsHeightPercent = 0.37 + extraContainerHeightPercent;
    }        
    else{
      columnMainAxisAlignment = MainAxisAlignment.spaceBetween;
      centerComponentsHeightPercent = 0.5275 + extraContainerHeightPercent;
    }
  }

  Widget _createCenterComponents(){
    return _chosenFormState.formStep == FormStep.OnForm? 
      FormInputsFraction(screenHeightPercent: centerComponentsHeightPercent)
      : CustomProgressIndicator(heightScreenPercentage: 0.45);
  }
}
