import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_keyboard_detector.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/eleccion_toma_o_finalizar.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/muestra_detail.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/pesos_chooser.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/preparacion_componentes.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/rango_edad_chosing.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
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
        //_addInitialMuestrasBlocPostFrameCall(context, state);
        return Column(
          children: [
            PageHeader(
              withTitle: (state is LoadedMuestreo),
              title: (state is LoadedMuestreo)? 'Muestra ${state.muestreo.tipo}': null,
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

  void _addInitialMuestrasBlocPostFrameCall(BuildContext context, MuestrasState state){
    if(state is MuestreoEmpty)
      _addInitialMuestrasBlocPostFrameCallIfMuestrasIsEmpty(context);
  }

  void _addInitialMuestrasBlocPostFrameCallIfMuestrasIsEmpty(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      BlocProvider.of<MuestrasBloc>(context).add( GetMuestreoEvent() );
    });
  }

  Widget _createBlocBuilderBottom(BuildContext context, MuestrasState state){
    if(state is MuestreoEmpty){
      _addBlocEventPostFrameCallBack(context, GetMuestreoEvent());
    }if(state is OnPreparacionMuestra)
      return PreparacionComponentes(muestra: state.muestreo);
    else if(state is OnEleccionTomaOFinalizar)
      return EleccionTomaOFinalizar(muestreo: state.muestreo);
    else if(state is OnChosingRangoEdad)
      return RangoEdadChosing(muestra: state.muestreo);
    else if(state is OnTomaPesos)
      return PesosChooser(muestra: state.muestreo, rangoEdadIndex: state.rangoEdadIndex);
    else if(state is OnMuestraDetail)
      return MuestraDetail(muestra: state.muestra, muestreoComponentes: state.muestreo.componentes);
    else if(state is MuestraRemoved)
      _addBlocEventPostFrameCallBack(context, BackFromMuestraDetail());
    else if(state is MuestraError)
      return Container(
        child: Center(
          child: Text(state.message),
        ),
      );
    return Container();
  }

  void _addBlocEventPostFrameCallBack(BuildContext context, MuestrasEvent event){
    WidgetsBinding.instance.addPostFrameCallback((_){
      BlocProvider.of<MuestrasBloc>(context).add( event );
    });
  }
}