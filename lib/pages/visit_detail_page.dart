import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/models/visit.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/navigation_list/button/navigation_list_button.dart';
import 'package:gap/utils/static_data/visit_detail_navigation.dart' as navigationData;

// ignore: must_be_immutable
class VisitDetailPage extends StatelessWidget {
  static final String route = 'visit_detail';
  final Color _activeIconColor = Color.fromRGBO(213, 199, 18, 1);
  final Color _activeTextColor = Colors.black87;
  final Color _inactiveItemColor = Colors.grey[300];
  final List<Map<String, dynamic>> navigationItemsParts = navigationData.navigationItemsParts;
  List<Map<String, Color>> _navItemsColors;
  List<bool> _navItemsActivation;
  BuildContext _context;
  SizeUtils _sizeUtils;
  Visit _visit;
  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: _createBodyComponents(),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext) {
    _context = appContext;
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createBodyComponents(){
    return BlocBuilder<VisitsBloc, VisitsState>(
      builder: (_, state) {
        if(state.chosenVisit != null){
          _visit = state.chosenVisit;
          _initNavItemsVisualFeatures();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              Header(withTitle: true, title: _visit.name),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createDateText(),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createNavigation(state)
            ],
          );
        }else{
          return Container(
            padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.02, vertical: _sizeUtils.xasisSobreYasis * 0.01),
            child: Container(   
              height: _sizeUtils.xasisSobreYasis * 0.35,
              decoration: BoxDecoration(
                color: Theme.of(_context).primaryColor,
                borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.02)
              ),
            ),
          );
        }
      },
    );
  }

  /**
   * La activación de los navItems se define así:
   *  *El primero está activo solo si la visita está pendiente.
   *  *Los siguientes dos están activos solo si la visita está realizada(ya no está pendiente)
   */
  void _initNavItemsVisualFeatures(){
    final bool visitaEstaPendiente = _visit.currentStage == ProcessStage.Pendiente;
    final Color iconColorItem1 = (visitaEstaPendiente)?_activeIconColor:_inactiveItemColor;
    final Color textColorItem1 = (visitaEstaPendiente)?_activeTextColor:_inactiveItemColor;
    final Color iconColorDemasItems = (visitaEstaPendiente)?_inactiveItemColor:_activeIconColor;
    final Color textColorDemasItems = (visitaEstaPendiente)?_inactiveItemColor:_activeTextColor;
    _navItemsColors = [
      {
        'icon':iconColorItem1,
        'text':textColorItem1,
      }
    ];
    _navItemsActivation = [visitaEstaPendiente];
    for(int i = 1; i <= 2; i++){
      _navItemsColors.add({'icon':iconColorDemasItems, 'text':textColorDemasItems});
      _navItemsActivation.add(!visitaEstaPendiente);
    }
  }

  Widget _createDateText(){
    final DateTime date = _visit.date;
    return Container(
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Text(
        'Fecha: ${date.toString().split(' ')[0]}',
        style: TextStyle(
          color: Theme.of(_context).primaryColor,
          fontSize: _sizeUtils.normalTextSize
        ),
      ),
    );
  }

  Widget _createNavigation(VisitsState state){
    final List<Widget> navigationItems = _createNavigationItems(state);
    return Container(
      padding: EdgeInsets.only(
        left: _sizeUtils.xasisSobreYasis * 0.035,
        right: _sizeUtils.xasisSobreYasis * 0.1
      ),
      child: Column(
        children: navigationItems,
      ),
    );
  }

  List<Widget> _createNavigationItems(VisitsState state){ 
    final List<Widget> items = [];
    for(int i = 0; i < navigationItemsParts.length; i++){
      final Map<String, dynamic> navItemParts = navigationItemsParts[i];
      items.add(
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.03),
          child: Row(
            children: [
              _createNavItemIcon(i, navItemParts['icon']),
              SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
              _createNavItemName(i, navItemParts['name'], navItemParts['navigation_route']),
            ],
          ),
        )
      );
    }
    return items;
  }

  Widget _createNavItemName(int itemIndex, String name, String navigationRoute){
    final Function onTap = _generateOnTapNavItemFunction(itemIndex, navigationRoute);
    return Expanded(
      child: NavigationListButton(
        name: name, 
        hasBottomBorder: false, 
        onTap: onTap
      )
    );
  }

  Function _generateOnTapNavItemFunction(int itemIndex, String navigationRoute){
    final Function onTap = (_navItemsActivation[itemIndex])? 
      (){Navigator.of(_context).pushNamed(navigationRoute);} 
      : null;
    return onTap;
  }

  Widget _createNavItemIcon(int itemIndex, IconData icon){
    return Icon(
      icon,
      size: _sizeUtils.largeIconSize,
      color: _navItemsColors[itemIndex]['icon'],
    );
  }
}