import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/form_fields_fraction.dart';
import 'package:gap/old_architecture/ui/widgets/indexing/index_pagination.dart';

class FormularioView extends StatelessWidget {
  final Formulario formulario;
  final Function(Formulario) onEnd;
  BuildContext context;
  FormularioView({
    @required this.formulario,
    @required this.onEnd,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _addPostFrameConfig();
    return SingleChildScrollView(
      child: Container(
        child: Center(child: BlocBuilder<IndexOldBloc, IndexState>(
          builder: (context, state) {
            if(state.nPages > 0){
              return Column(
                children: [
                  FormInputsFraction(
                    screenHeightPercent: 0.7,
                    formFieldsAreEnabled: true,
                  ),
                  BottomFormNavigation(
                    onTapMuestrasBlocEvent: onEnd,
                    indexNPages: state.nPages,
                    indexPage: state.currentIndexPage,
                    sePuedeRetroceder: state.sePuedeRetroceder,
                    sePuedeAvanzar: state.sePuedeAvanzar,
                  )
                ],
              );
            }
            return Container();
          },
        )),
      ),
    );
  }

  void _addPostFrameConfig() {
    //TODO: Cambiar cuando se haya implementado clean architecture
    BlocProvider.of<ChosenFormBloc>(context).add(InitFormFillingOut(
        formulario: FormularioOld.fromFormularioNew(this.formulario),
        onEndEvent: _changeIndex));
  }

  void _changeIndex(int nPages) {
    BlocProvider.of<IndexOldBloc>(context).add(ChangeNPages(nPages: nPages));
  }
}


// ignore: must_be_immutable
class BottomFormNavigation extends StatelessWidget {
  final Function(Formulario) onTapMuestrasBlocEvent;
  final int indexNPages;
  final bool sePuedeAvanzar;
  final bool sePuedeRetroceder;
  final int indexPage;
  BuildContext context;
  BottomFormNavigation({
    @required this.onTapMuestrasBlocEvent,
    @required this.indexNPages,
    @required this.sePuedeAvanzar,
    @required this.sePuedeRetroceder,
    @required this.indexPage,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Column(
      children: [
        IndexPagination(),
        _createAdvanceButton()
      ]
    );

  }
  
  Widget _createAdvanceButton(){
    if(indexPage == indexNPages-1)
      return GeneralButton(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        text: 'Siguiente',
        onPressed: _getOnPressAdvanceButtonFunction(),
      );
    else
      return Container();
  }

  Function _getOnPressAdvanceButtonFunction(){
    if(ChosenFormManagerSingleton.chosenFormManager.canGoToNextFormStep()){
      return (){
        BlocProvider.of<IndexOldBloc>(context).add(ResetAllOfIndex());
        final List<CustomFormFieldOld> formFields = BlocProvider.of<ChosenFormBloc>(context).state.allFields;
        Formulario formulario = (BlocProvider.of<MuestrasBloc>(context).state as LoadedFormulario).formulario..campos = formFields;
        onTapMuestrasBlocEvent(formulario);
      };
    }else
      return null;
  }
}