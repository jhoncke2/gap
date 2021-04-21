import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/old_architecture/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/bottom_containers/bottom_firms_options.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/first_firmer_firm.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/first_firmer_pers_info.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/secondary_firmer_firm.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/loaded_form_head.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/buttons/general_button.dart';
import 'package:gap/old_architecture/ui/widgets/form_process_container.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/widgets/progress_indicator.dart';

// ignore: must_be_immutable
class FirmersPage extends StatelessWidget {
  static final String route = 'firmers';
  static final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  Widget header;
  Widget separer;
  Widget body;
  
  FirmersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NativeBackButtonLocker(
        child: SafeArea(
          child: GestureDetector(
            child: _createAlignedComponents(),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            }
          ),
        ),
      ),
    );
  }

  Widget _createAlignedComponents(){
    return BlocBuilder<KeyboardListenerBloc, KeyboardListenerState>(
      builder: (context, keyboardState) {
        final FormulariosState formsState = BlocProvider.of<FormulariosBloc>(_context).state;
        _defineConfigByKeyboardState(keyboardState, formsState);
        return Column(
          children: [
            //TODO: Revisar si este container sirve para algo
            Container(),
            header,
            separer,
            body
          ],
        );
      },
    );
  }

  void _defineConfigByKeyboardState(KeyboardListenerState keyboardState, FormulariosState formsState) {
    MainAxisAlignment bodyMainAxisAlignment;
    if(keyboardState.isActive){
      header = Container();
      separer = SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.0);
      bodyMainAxisAlignment = MainAxisAlignment.start;
    }else{
      header = LoadedFormHead(formsState: formsState);
      separer = SizedBox(height: _sizeUtils.littleSizedBoxHeigh);
      bodyMainAxisAlignment = MainAxisAlignment.spaceBetween;
    }
    body = FormProcessMainContainer(
      formName: formsState.chosenForm.name,
      bottomChild: _FirmerComponents(keyboardIsActive: keyboardState.isActive),
      mainAxisAlignment: bodyMainAxisAlignment,
      separerHeightPercent: keyboardState.isActive? 0.023 : 0.0,
    );
  }
}


// ignore: must_be_immutable
class _FirmerComponents extends StatelessWidget {
  
  final bool keyboardIsActive;
  BuildContext _context;
  Widget _bodyWidget;
  Widget _bottomWidget;
  _FirmerComponents({Key key, @required this.keyboardIsActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    final double screenHeight = MediaQuery.of(_context).size.height;
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (context, state) {
        _defineWidgetsByState(state);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bodyWidget,
              SizedBox(height: screenHeight * (this.keyboardIsActive? 0.03 : 0.15)),
              _bottomWidget
            ],
          ),
        );
      },
    );
  }

  void _defineWidgetsByState(ChosenFormState state) {
    if (state.formStep == FormStep.OnFirstFirmerInformation) {
      _defineOnFirstFirmerInformationWidgets();
    } else if (state.formStep == FormStep.OnFirstFirmerFirm) {
      _defineOnFirstFirmerFirmWidgets();
    } else if (state.formStep == FormStep.OnSecondaryFirms) {
      _defineOnSecondaryFirmsWidgets();
    } else {
      _defineOnNothingWidgets();
    }
  }

  void _defineOnFirstFirmerInformationWidgets() {
    _bodyWidget = FirstFirmerPersInfo();
    _bottomWidget = GeneralButton(
      backgroundColor: Theme.of(_context).secondaryHeaderColor,
      text: 'Siguiente',
      onPressed: _onFirstFirmerPersInfoPressed,
    );
  }

  void _onFirstFirmerPersInfoPressed() {
    if (ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep())
      PagesNavigationManager.initFirstFirmerFirm();
  }

  void _defineOnFirstFirmerFirmWidgets() {
    _bodyWidget = FirstFirmerFirm();
    _bottomWidget = BottomFirmsOptions();
  }

  void _defineOnSecondaryFirmsWidgets() {
    _bodyWidget = SecondaryFirmerFirm();
    _bottomWidget = BottomFirmsOptions();
  }

  void _defineOnNothingWidgets() {
    _bodyWidget = CustomProgressIndicator(heightScreenPercentage: 0.4);
    _bottomWidget = Container();
  }
}