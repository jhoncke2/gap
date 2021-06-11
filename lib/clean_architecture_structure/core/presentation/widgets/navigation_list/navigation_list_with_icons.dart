import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/button_with_icon.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

// ignore: must_be_immutable
class VisitNavigationList extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final Visit visit;
  Color iconColorItem1;  
  Color textColorItem1;
  Color iconColorDemasItems;
  Color textColorDemasItems;  
  BuildContext context;

  VisitNavigationList({
    @required this.visit  
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _initNavItemsVisualFeatures();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _sizeUtils.xasisSobreYasis * 0.03
      ),
      child: Column(
        children: [
          _createIniciarVisitaWidget(),          
          _createAdjuntarImagenesWidget(),
          _createVisualizarVisitaWidget(),          
        ],
      ),
    );
  }

  void _initNavItemsVisualFeatures(){
    final Color activeFirstIconColor = Color.fromRGBO(213, 199, 18, 1);
    final Color activeOtherIconsColor = Colors.black54;
    final Color activeTextColor = Colors.black87;
    final Color inactiveItemColor = Colors.grey[300];
    iconColorItem1 = (visit.completo)? inactiveItemColor : activeFirstIconColor;
    textColorItem1 = (visit.completo)? inactiveItemColor : activeTextColor;
    iconColorDemasItems = (visit.completo)?activeOtherIconsColor : inactiveItemColor;
    textColorDemasItems = (visit.completo)?activeTextColor : inactiveItemColor;
  }

  Widget _createIniciarVisitaWidget(){
    return ButtonWithIcon(
      name: 'Iniciar visita', 
      textColor: textColorItem1,
      icon: FontAwesomeIcons.longArrowAltRight, 
      iconColor: iconColorItem1, 
      onTap: (visit.completo)? null : _onTapIniciarVisita
    );
  }

  void _onTapIniciarVisita(){
    if(visit.hasMuestreo)
      _navToMuestras();
    else
      _navToFormularios(); 
  }

  _navToMuestras(){
    BlocProvider.of<NavigationBloc>(context).add(NavigateToEvent(navigationRoute: NavigationRoute.Muestras));
    Navigator.of(context).pushReplacementNamed(NavigationRoute.Muestras.value);
  }

  void _navToFormularios(){
    //BlocProvider.of<NavigationBloc>(context).add(NavigateToEvent(navigationRoute: NavigationRoute.Formularios));
    //Navigator.of(context).pushReplacementNamed(NavigationRoute.Formularios.value);
    //TODO: Cambiar cuando se haya implementado clean architecture
    PagesNavigationManager.navToForms();
  }

  Widget _createAdjuntarImagenesWidget(){
    return ButtonWithIcon(
      name: 'Adjuntar imágenes', 
      textColor: textColorDemasItems,
      icon: Icons.attach_file, 
      iconColor: iconColorDemasItems, 
      onTap: (visit.completo)? _onTapAdjuntarImagenes : null
    );
  }

  void _onTapAdjuntarImagenes(){
    //TODO: Arreglar cuando se haya implementado clean architecture en esas pages
    PagesNavigationManager.navToCommentedImages();
  }

  Widget _createVisualizarVisitaWidget(){
    return ButtonWithIcon(
      name: 'Visualizar visita', 
      textColor: textColorDemasItems,
      icon: Icons.remove_red_eye, 
      iconColor: iconColorDemasItems, 
      onTap: (visit.completo)? _onTapVisualizarVisita : null
    );
  }

  void _onTapVisualizarVisita(){
    //TODO: Arreglar cuando se haya implementado clean architecture en esas pages
    PagesNavigationManager.navToForms();
  }
}