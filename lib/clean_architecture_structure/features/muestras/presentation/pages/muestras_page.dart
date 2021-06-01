import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_keyboard_detector.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/eleccion_rangos_a_usar.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/eleccion_toma_o_finalizar.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/formulario_final.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/formulario_inicial.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/muestra_detail.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/muestreo_step_choser.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/pesos_chooser.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/preparacion_componentes.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/rango_edad_chosing.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class MuestrasPage extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  MuestrasPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sizeUtils.initUtil(MediaQuery.of(context).size);
    return ScaffoldKeyboardDetector(
      child: SafeArea(
        child: BlocProvider<MuestrasBloc>(
          create: (context) => sl(),
          child: Container(
            color: Colors.transparent,
            child: _createMuestrasBlocBuilder(),
          ),
        ),
      ),
    );
  }

  Widget _createMuestrasBlocBuilder(){
    return BlocBuilder<MuestrasBloc, MuestrasState>(
      builder: (context, state) {
        return Column(
          children: [
            PageHeader(
              withTitle: (state is LoadedMuestreo),
              title: (state is LoadedMuestreo)? '${state.muestreo.tipo}': 'Muestra',
              titleIsUnderlined: false,
            ),
            SizedBox(height: sizeUtils.xasisSobreYasis * 0.05),
            Expanded(
              child: _createBlocBuilderBottom(context, state)
            )
          ],
        );
      },
    );
  }

  Widget _createBlocBuilderBottom(BuildContext context, MuestrasState state){
    if(state is OnMuestreoEmpty){
      _addBlocEventPostFrameCallBack(context, InitMuestreoEvent());
      return CustomProgressIndicator(heightScreenPercentage: 0.6);
    }
    else if(state is LoadedInitialFormulario)
      return FormularioInicial(formulario: state.formulario);
    else if(state is OnChooseMuestreoStep)
      return MuestreoStepChoser();
    else if(state is OnPreparacionMuestreo)
      return PreparacionComponentes(muestra: state.muestreo);
    else if(state is OnChooseRangosAUsar)
      return EleccionRangosAUsar(rangos: state.muestreo.rangos);
    else if(state is OnChooseAddMuestraOFinalizar)
      return EleccionTomaOFinalizar(muestreo: state.muestreo);
    else if(state is OnChosingRangoEdad)
      return RangoEdadChosing(muestra: state.muestreo);
    else if(state is OnTomaPesos)
      return PesosChooser(muestra: state.muestreo, rangoEdadId: state.rangoId);
    else if(state is OnMuestraDetail)
      return MuestraDetail(muestra: state.muestra, muestreoComponentes: state.muestreo.componentes);
    else if(state is MuestraRemoved)
      _addBlocEventPostFrameCallBack(context, BackFromMuestraDetail());
    else if(state is LoadedFinalFormulario)
      return FormularioFinal(formulario: state.formulario);
    else if(state is MuestraError)
      return Container(
        child: Center(
          child: Text(state.message),
        ),
      );
    else if(state is MuestreoFinished)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //BlocProvider.of<NavigationBloc>(context).add(NavigateToEvent(navigationRoute: NavigationRoute.Formularios));
        //Navigator.of(context).pushReplacementNamed(NavigationRoute.Formularios.value);
        PagesNavigationManager.navToForms();
      });
    return CustomProgressIndicator(
      heightScreenPercentage: 0.75,
    );
  }

  void _addBlocEventPostFrameCallBack(BuildContext context, MuestrasEvent event){
    WidgetsBinding.instance.addPostFrameCallback((_){
      BlocProvider.of<MuestrasBloc>(context).add( event );
    });
  }
}