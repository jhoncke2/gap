import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class EleccionTomaOFinalizar extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  final Muestra muestra;
  EleccionTomaOFinalizar({
    @required this.muestra,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            'Número de muestreos hechos: ${muestra.nMuestreos}',
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
            text: 'Hacer muestreo',
            backgroundColor: Theme.of(context).primaryColor, 
            onPressed: ()=>_hacerMuestreo(context)
            
          ),
          GeneralButton(
            text: 'Finalizar',
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: _finalizar
          )
        ],
      ),
    );
  }

  void _hacerMuestreo(BuildContext context){
    BlocProvider.of<MuestrasBloc>(context).add(AddNewTomaDeMuestra());
  }

  void _finalizar(){

  }
}