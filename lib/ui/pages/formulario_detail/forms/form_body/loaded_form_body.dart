import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/widgets/form_process_container.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';
import 'bottom_containers/bottom_firms_options.dart';
import 'bottom_containers/bottom_formfilling_navigation.dart';
import 'center_containers/first_firmer_firm.dart';
import 'center_containers/first_firmer_pers_info.dart';
import 'center_containers/form_fields_fraction.dart';
import 'center_containers/secondary_firmer_firm.dart';

// ignore: must_be_immutable
class LoadedFormBody extends StatelessWidget{
  final FormulariosState formsState;
  final Formulario _formulario;

  LoadedFormBody({
    @required this.formsState
  }):
    _formulario = formsState.chosenForm
    ;
  @override
  Widget build(BuildContext context) {
    return FormProcessMainContainer(
      formName: _formulario.name,
      bottomChild: _ChosenFormCurrentComponent()
    );
  }
}

// ignore: must_be_immutable
class _ChosenFormCurrentComponent extends StatelessWidget {
  ChosenFormState _state;
  Widget _centerComponents;
  Widget _bottomComponents;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (context, state) {
        _state = state;
        _elegirComponentsSegunFormState();
        return Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _centerComponents,
                //SizedBox(height: _sizeUtils.giantSizedBoxHeight),
                _bottomComponents
              ],
            ),
            padding: EdgeInsets.only(top: 45),
          ),
        );
      },
    );
  }

  void _elegirComponentsSegunFormState(){
    switch(_state.formStep){      
      case FormStep.WithoutForm:
        _centerComponents = UnloadedNavItems();
        _bottomComponents = Container();
        break;
      case FormStep.OnForm:
        _centerComponents = FormInputsFraction();
        _bottomComponents = BottomFormFillingNavigation();
        break;
      case FormStep.OnFirstFirmerInformation:
        _centerComponents = FirstFirmerPersInfo();
        _bottomComponents = BottomFormFillingNavigation();
        break;
      case FormStep.OnFirstFirmerFirm:
        _centerComponents = FirstFirmerFirm();
        _bottomComponents = BottomFirmsOptions();
        break;
      case FormStep.OnSecondaryFirms:
        _centerComponents = SecondaryFirmerFirm();
        _bottomComponents = BottomFirmsOptions();
        break;
      default:
        _centerComponents = Container();
        _bottomComponents = Container();
    }
  }
}