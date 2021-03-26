import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/ui/widgets/progress_indicator.dart';
import 'bottom_containers/bottom_formfilling_navigation.dart';
import 'center_containers/form_fields_fraction.dart';

// ignore: must_be_immutable
class ChosenFormCurrentComponent extends StatelessWidget {
  ChosenFormState _state;
  Widget _centerComponents;
  Widget _bottomComponents;

  MainAxisAlignment columnMainAxisAlignment;
  double centerComponentsHeightPercent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (context, state) {
        _state = state;
        _elegirComponentsSegunFormState();
        return Expanded(
          child: BlocBuilder<KeyboardListenerBloc, KeyboardListenerState>(
            builder: (context, state) {
              _defineColumnComponentsConfigByKeyboardState(state.isActive);
              return Container(
                color: Colors.redAccent,
                child: Column(
                  mainAxisAlignment: columnMainAxisAlignment,
                  children: [
                    _createCenterComponents(),
                    //SizedBox(height: _sizeUtils.giantSizedBoxHeight),
                    _bottomComponents
                  ],
                ),
                padding: EdgeInsets.only(top: 45),
              );
            },
          ),
        );
      },
    );
  }

  void _defineColumnComponentsConfigByKeyboardState(bool keyBoardIsActive){
    if(keyBoardIsActive){
      columnMainAxisAlignment = MainAxisAlignment.start;
      centerComponentsHeightPercent = 0.3;
    }        
    else{
      columnMainAxisAlignment = MainAxisAlignment.spaceBetween;
      centerComponentsHeightPercent = 0.65;
    }
  }

  void _elegirComponentsSegunFormState() {
    if (_state.formStep == FormStep.OnForm) {
      _centerComponents = FormInputsFraction(screenHeightPercent: centerComponentsHeightPercent);
      _bottomComponents = BottomFormFillingNavigation();
    } else {
      _centerComponents = CustomProgressIndicator(heightScreenPercentage: 0.45);
      _bottomComponents = Container();
    }
  }

  Widget _createCenterComponents(){
    return _state.formStep == FormStep.OnForm? 
      FormInputsFraction(screenHeightPercent: centerComponentsHeightPercent)
      : CustomProgressIndicator(heightScreenPercentage: 0.45);
  }
}
