import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/bottom_containers/bottom_firms_options.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/center_containers/first_firmer_firm.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/center_containers/first_firmer_pers_info.dart';
import 'package:gap/ui/pages/formulario_detail/forms/form_body/center_containers/secondary_firmer_firm.dart';
import 'package:gap/ui/pages/formulario_detail/forms/loaded_form_head.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/form_process_container.dart';
import 'package:gap/ui/widgets/progress_indicator.dart';

// ignore: must_be_immutable
class FirmersPage extends StatelessWidget{

  static final String route = 'firmers';
  static final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  Widget _bodyWidget;
  Widget _bottomWidget;
  FirmersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    final FormulariosState formsState = BlocProvider.of<FormulariosBloc>(context).state;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        child: Column(
          children: [
            SafeArea(child: Container()),
            LoadedFormHead(formsState: formsState),
            SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
            FormProcessMainContainer(
              formName: formsState.chosenForm.name,
              bottomChild: _createFirmsWidgets(),
            )
          ],
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      ),
    );
  }

  Widget _createFirmsWidgets(){
    final double screenHeight = MediaQuery.of(_context).size.height;
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (context, state) {
        _defineWidgetsByState(state);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bodyWidget,
              SizedBox(height: screenHeight * 0.15),
              _bottomWidget
            ],
          ),
        );
      },
    );
  }

  void _defineWidgetsByState(ChosenFormState state){
    if(state.formStep == FormStep.OnFirstFirmerInformation){
      _defineOnFirstFirmerInformationWidgets();
    }else if(state.formStep == FormStep.OnFirstFirmerFirm){
      _defineOnFirstFirmerFirmWidgets();
    }else if(state.formStep == FormStep.OnSecondaryFirms){
      _defineOnSecondaryFirmsWidgets();
    }else{
      _defineOnNothingWidgets();
    }
  }

  void _defineOnFirstFirmerInformationWidgets(){
    _bodyWidget = FirstFirmerPersInfo();
    _bottomWidget = GeneralButton(
      backgroundColor: Theme.of(_context).secondaryHeaderColor,
      text: 'Siguiente',
      onPressed: _onFirstFirmerPersInfoPressed,
    );
  }

  void _onFirstFirmerPersInfoPressed(){
    if(ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep())
      PagesNavigationManager.initFirstFirmerFirm();
  }

  void _defineOnFirstFirmerFirmWidgets(){
    _bodyWidget = FirstFirmerFirm();
    _bottomWidget = BottomFirmsOptions();
  }

  void _defineOnSecondaryFirmsWidgets(){
    _bodyWidget = SecondaryFirmerFirm();
    _bottomWidget = BottomFirmsOptions();
  }

  void _defineOnNothingWidgets(){
    _bodyWidget = CustomProgressIndicator(heightScreenPercentage: 0.4);
    _bottomWidget = Container();
  }
}