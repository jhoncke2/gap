import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/models/entities/formulario.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/forms/firms/first_firmer_information.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields_fraction.dart';
import 'package:gap/ui/widgets/forms/form_inputs_index.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';

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
            _ChosenFormCurrentComponent(),
            Container(),
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
  
}

// ignore: must_be_immutable
class _ChosenFormCurrentComponent extends StatelessWidget {
  ChosenFormState _state;
  Widget _components;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (context, state) {
        _state = state;
        _elegirComponentSegunFormState();
        return _components;
      },
    );
  }

  void _elegirComponentSegunFormState(){
    switch(_state.formStep){      
      case FormStep.WithoutForm:
        _components = UnloadedNavItems();
        break;
      case FormStep.OnForm:
        _components = FormInputsFraction();
        break;
      case FormStep.OnFirstFirmerInformation:
        _components = FirstFirmerInformation();
        break;
      case FormStep.OnFirstFirmerFirm:
        _components = UnloadedNavItems();
        break;
      case FormStep.OnFirms:
        _components = UnloadedNavItems();
        break;
      default:
        _components = Container();
    }
  }
}


// ignore: must_be_immutable
