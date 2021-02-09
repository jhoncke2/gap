import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/bottom_containers/bottom_firms_options.dart';
import 'package:gap/ui/widgets/forms/form_body/bottom_containers/bottom_formfilling_navigation.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/first_firmer_firm.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/first_firmer_pers_info.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields_fraction.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/secondary_firmer_firm.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';

// ignore: must_be_immutable
class LoadedFormBody extends StatelessWidget{
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  final Formulario _formulario;

  LoadedFormBody({
    @required this.formsState
  }):
    _formulario = formsState.chosenForm
    ;
  @override
  Widget build(BuildContext context) {
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
            _ChosenFormCurrentComponent()
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
  
}

// ignore: must_be_immutable
class _ChosenFormCurrentComponent extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  ChosenFormState _state;
  Widget _centerComponents;
  Widget _bottomComponents;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (context, state) {
        _state = state;
        _elegirComponentsSegunFormState();
        return Container(
          height: _sizeUtils.xasisSobreYasis * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _centerComponents,
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _bottomComponents
            ],
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


// ignore: must_be_immutable
