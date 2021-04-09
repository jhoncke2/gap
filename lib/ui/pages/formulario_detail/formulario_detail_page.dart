import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/form_process_container.dart';
import 'package:gap/ui/widgets/native_back_button_locker.dart';
import 'package:gap/ui/widgets/progress_indicator.dart';
import 'forms/form_body/chosen_form_current_component.dart';
import 'forms/loaded_form_head.dart';

// ignore: must_be_immutable
class FormularioDetailPage extends StatelessWidget {
  static final String route = 'formulario_detail';
  FormularioDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NativeBackButtonLocker(
        child: SingleChildScrollView(
          child: GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  SafeArea(
                    child: _createFormBuilder(),
                    bottom: false,
                    maintainBottomViewPadding: true,
                  ),
                ],
              ),
            ),
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            }
          ),
        ),
      )
    );
  }

  Widget _createFormBuilder() {
    return BlocBuilder<FormulariosBloc, FormulariosState>(
      builder: (context, state) {
        if (state.chosenForm != null) {
          return _LoadedFormularioDetail(formsState: state);
        } else {
          return CustomProgressIndicator(heightScreenPercentage: 0.85);
        }
      },
    );
  }
}

// ignore: must_be_immutable
class _LoadedFormularioDetail extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  double containerHeight;
  Widget header;
  Widget separer;
  _LoadedFormularioDetail({@required this.formsState});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, indexState) {
        if(indexState.nPages > 0){
          return BlocBuilder<KeyboardListenerBloc, KeyboardListenerState>(
            builder: (context, keyboardState) {
              _defineConfigByBlocsStates(keyboardState, indexState, context);
              return _createWidgetWithBlocBuilderConfigDefined();
            },
          );
        }else{
          return CustomProgressIndicator(heightScreenPercentage: 0.6,);
        }
      },
    );
  }

  Widget _createWidgetWithBlocBuilderConfigDefined(){
    return Container(
      height: containerHeight,
      margin: EdgeInsets.all(0),
      child: Column(
        children:[
          header,
          separer,
          FormProcessMainContainer(
            formName: formsState.chosenForm.name,
            bottomChild: ChosenFormCurrentComponent()
          )
        ],
      )
    );
  }

  void _defineConfigByBlocsStates(KeyboardListenerState keyboardState, IndexState indexState, BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    if(keyboardState.isActive){
      containerHeight = screenHeight * 0.965;
      header = Container();
      separer = SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.0);
    }else{
      containerHeight = screenHeight * 0.955;
      header = _createLoadedFormHead();
      separer = SizedBox(height: _sizeUtils.littleSizedBoxHeigh);
    }
  }

  Widget _createLoadedFormHead(){
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (_, chosenFormState){
        if([FormStep.OnFormFillingOut, FormStep.Finished].contains( chosenFormState.formStep ))
          return LoadedFormHead(formsState: formsState, hasBackButton: true);
        else
          return LoadedFormHead(formsState: formsState, hasBackButton: false);
      },
    );
  }
}