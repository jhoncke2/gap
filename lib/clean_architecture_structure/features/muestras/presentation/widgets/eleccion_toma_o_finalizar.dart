import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class EleccionTomaOFinalizar extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  final Muestreo muestreo;
  BuildContext context;
  EleccionTomaOFinalizar({
    @required this.muestreo,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    this.context = context;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            'Número de muestras: ${muestreo.nMuestras}',
            style: TextStyle(
              fontSize: sizeUtils.subtitleSize
            ),
          ),
          MuestrasHechas(muestreo: muestreo),
          _createBottomButtons(context),
        ],
      ),
    );
  }

  Widget _createBottomButtons(BuildContext context){
    return Container(
      padding: EdgeInsets.only(bottom: 35),
      child: Column(
        children: [
          GeneralButton(
            text: 'Tomar muestra',
            backgroundColor: Theme.of(context).primaryColor, 
            onPressed: _canAddMuestreo()? ()=> _hacerMuestreo(context) : null
          ),
          GeneralButton(
            text: 'Finalizar',
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: _muestraCanFinish()? _finalizar : null
          )
        ],
      ),
    );
  }

  bool _canAddMuestreo() => muestreo.nMuestras < muestreo.maxMuestras;

  void _hacerMuestreo(BuildContext context){
    BlocProvider.of<MuestrasBloc>(context).add(InitNewMuestra());
  }

  bool _muestraCanFinish() => !muestreo.obligatorio || ( muestreo.minMuestras <= muestreo.nMuestras);

  void _finalizar(){
    //TODO: Cambiar cuando se haya implementado el nuevo FormulariosPage
    //PagesNavigationManager.navToForms();
    BlocProvider.of<MuestrasBloc>(context).add(EndTomaMuestras());
  }
}

// ignore: must_be_immutable
class MuestrasHechas extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  final Muestreo muestreo;
  List<int> nComponentesPorRango;
  MuestrasHechas({
    @required this.muestreo, 
    Key key
  }) :super(key: key){
    this.nComponentesPorRango = this.muestreo.rangos.map(
      (_)=>0
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Muestras hechas',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: sizeUtils.subtitleSize,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: sizeUtils.size.width * 0.1),
            children: _generateMuestras(context)
          ),
        ),
      ],
    );
  }

  List<Widget> _generateMuestras(BuildContext context){
    return muestreo.muestrasTomadas.map(
      (mT){
        int rangoIndex = muestreo.rangos.indexWhere((r) => r.nombre == mT.rango);
        nComponentesPorRango[rangoIndex]++;
        return _createCurrentMuestraButton(context, mT, nComponentesPorRango[rangoIndex]);
      }
    ).toList();
  }

  Widget _createCurrentMuestraButton(BuildContext context, Muestra muestra, int muestraRangoIndex){
    return Container(
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '$muestraRangoIndex',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: sizeUtils.subtitleSize
              ),
            ),
            Text(
              '${muestra.rango}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: sizeUtils.normalTextSize
              )
            ),
            Container(),
          ],
        ),
        onPressed: (){
          BlocProvider.of<MuestrasBloc>(context).add(ChooseMuestra(muestra: muestra));
          /*
          showDialog(
            context: context, 
            builder: (_)=>Dialog(
              child: MuestraDetail(),
            ),
            useRootNavigator: false
          );
          */
        },
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5
          )
        )
      ),
    );
  }
}