import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class MuestreoStepChoser extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  BuildContext context;
  MuestreoStepChoser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.075
      ),
      child: Column(
        children: [
          _createSingleNavButton('Llenar pre-formulario', _hacerPreFormulario),
          _createSingleNavButton('Tomar muestras', _tomarMuestras),
          _createSingleNavButton('Llenar post-formulario', _hacerPostFormulario)
        ],
      ),
    );
  }

  Widget _createSingleNavButton(String name, Function function){
    return NavigationListButton(
      child: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: sizeUtils.subtitleSize
        ),
      ),
      textColor: Theme.of(context).primaryColor,
      hasBottomBorder: true,
      onTap: function
    );
  }

  void _hacerPreFormulario(){

  }
  
  void _tomarMuestras(){
    BlocProvider.of<MuestrasBloc>(context).add(InitTomaMuestras());
  }

  void _hacerPostFormulario(){

  }
}