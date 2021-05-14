import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class EleccionTomaOFinalizar extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  final Muestreo muestra;
  EleccionTomaOFinalizar({
    @required this.muestra,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            'Número de muestras: ${muestra.nMuestras}',
            style: TextStyle(
              fontSize: sizeUtils.subtitleSize
            ),
          ),
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

  bool _canAddMuestreo() => muestra.nMuestras < muestra.maxMuestras;

  void _hacerMuestreo(BuildContext context){
    BlocProvider.of<MuestrasBloc>(context).add(InitNewMuestra());
  }

  bool _muestraCanFinish() => !muestra.obligatorio || ( muestra.minMuestras <= muestra.nMuestras);

  void _finalizar(){
    //TODO: Cambiar cuando se haya implementado el nuevo FormulariosPage
    PagesNavigationManager.navToForms();
  }
}

class MuestreosHechos extends StatelessWidget {
  final Muestreo muestra;
  final List<int> nComponentesPorRango;
  MuestreosHechos({
    @required this.muestra, 
    Key key
  }) : 
    this.nComponentesPorRango = [],
    super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Componente> componentes = this.muestra.componentes;
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        children: componentes.map(
          (c) =>  Container(
            child: Row(
              children: [
                Text('')
              ],
            ),
          )
        ).toList(),
      ),
    );
  }

  Widget _generateMuestreos(){
    List<Componente> componentes = this.muestra.componentes;
    for(int i = 0; i < muestra.nMuestras; i++){
    }
  }
}