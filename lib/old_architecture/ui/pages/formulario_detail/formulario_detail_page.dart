import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/form_process_container.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'forms/form_body/chosen_form_current_component.dart';
import 'forms/loaded_form_head.dart';

// ignore: must_be_immutable
class FormularioDetailPageOld extends StatelessWidget {
  static final String route = 'formulario_detail';
  FormularioDetailPageOld({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: NativeBackButtonLocker(
          child: BlocProvider<NavigationBloc>(
            create: (context) => sl(),
            child: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                if(state is InactiveNavigation)
                  return _createUnNavigatedWidget(context);
                else if(state is Popped){
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context).pushReplacementNamed(state.navRoute.value);
                  });
                }
                return Container();
              },
            )
          ),
        ));
  }

  Widget _createUnNavigatedWidget(BuildContext context){
    return SingleChildScrollView(
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
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          }),
    );
  }

  Widget _createFormBuilder() {
    return BlocBuilder<FormulariosOldBloc, FormulariosState>(
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
    return BlocBuilder<KeyboardListenerBloc, KeyboardListenerState>(
      builder: (context, keyboardState) {
        _defineConfigByBlocsStates(keyboardState, context);
        return Container(
            height: containerHeight,
            margin: EdgeInsets.all(0),
            child: Column(
              children: [header, separer, _createIndexBuilder()],
            ));
      },
    );
  }

  Widget _createIndexBuilder() {
    return BlocBuilder<IndexOldBloc, IndexState>(
      builder: (context, indexState) {
        if (indexState.nPages > 0) {
          return FormProcessMainContainer(
              formName: formsState.chosenForm.name,
              bottomChild: ChosenFormCurrentComponent());
        } else {
          return CustomProgressIndicator(
            heightScreenPercentage: 0.6,
          );
        }
      },
    );
  }

  void _defineConfigByBlocsStates(
      KeyboardListenerState keyboardState, BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    if (keyboardState.isActive) {
      containerHeight = screenHeight * 0.9625;
      header = Container();
      separer = SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.0);
    } else {
      containerHeight = screenHeight * 0.94;
      header = _createLoadedFormHead();
      separer = SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.0);
    }
  }

  Widget _createLoadedFormHead() {
    return BlocBuilder<ChosenFormBloc, ChosenFormState>(
      builder: (_, chosenFormState) {
        if ([FormStep.OnFormFillingOut, FormStep.Finished]
            .contains(chosenFormState.formStep))
          return LoadedFormHead(formsState: formsState, hasBackButton: true);
        else
          return LoadedFormHead(formsState: formsState, hasBackButton: false);
      },
    );
  }
}
