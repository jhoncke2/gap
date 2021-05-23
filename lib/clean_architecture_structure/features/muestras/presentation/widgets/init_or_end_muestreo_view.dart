import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class InitOrEndMuestreoView extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  List<String> elementsNames;
  List<Function> elementsFunctions;
  BuildContext context;

  InitOrEndMuestreoView({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sizeUtils.xasisSobreYasis * 0.075),
      child: Column(
        children: [
          SizedBox(height: 50),
          _createSingleNavButton('Iniciar muestra', _initMuestreo),
          _createSingleNavButton('Ir a formularios', _gotToFormularios)
        ],
      ),
    );
  }

  void _initMuestreo(){
    BlocProvider.of<MuestrasBloc>(context).add(GetMuestreoEvent());
  }

  void _gotToFormularios(){
    //TODO: Quitar cuando haya implementado clean architecture en formularios
    PagesNavigationManager.navToForms();
    //BlocProvider.of<NavigationBloc>(context).addError(NavigateToEvent(navigationRoute: NavigationRoute.Formularios));
    //Navigator.of(context).pushReplacementNamed(NavigationRoute.Formularios.value);
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
}