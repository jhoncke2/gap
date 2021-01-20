import 'package:flutter/material.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/navigation_list/button/button_with_icon.dart';
import 'package:gap/widgets/navigation_list/navigation_list.dart';
import 'package:gap/utils/static_data/visit_detail_navigation.dart' as navigationData;
// ignore: must_be_immutable
class NavigationListWithIcons extends NavigationList{
  final SizeUtils _sizeUtils = SizeUtils();
  final Color _activeIconColor = Color.fromRGBO(213, 199, 18, 1);
  final Color _activeTextColor = Colors.black87;
  final Color _inactiveItemColor = Colors.grey[300];
  final ProcessStage currentVisitProcessState;
  final List<IconData> icons = [];
  final List<Map<String, dynamic>> navigationItemsParts = navigationData.navigationItemsParts;
  List<Map<String, Color>> _navItemsColors;
  List<bool> _navItemsActivation;

  NavigationListWithIcons({
    @required this.currentVisitProcessState,
  }):super(
    itemsNames: [],
    itemsFunctions: [],
  );

  @override
  Widget createNavList() {
    _initNavItemsVisualFeatures();
    _defineFunctionsAndNames();
    final List<Widget> navigationItems = _createNavigationItems();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _sizeUtils.xasisSobreYasis * 0.03
      ),
      child: Column(
        children: navigationItems,
      ),
    );
  }

  void _initNavItemsVisualFeatures(){
    final bool visitaEstaPendiente = currentVisitProcessState == ProcessStage.Pendiente;
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

  void _defineFunctionsAndNames(){
    this.itemsFunctions = [];
    for(int i = 0; i < navigationItemsParts.length; i++){
      final Map<String, dynamic> itemPart = navigationItemsParts[i];
      this.itemsFunctions.add(
        _generateFunctionByItemActivation(_navItemsActivation[i], itemPart['navigation_route'])
      );
      this.itemsNames.add(itemPart['name']);
      this.icons.add(
        itemPart['icon']
      );
    }
  }

  Function _generateFunctionByItemActivation(bool itemActivation, String navigationRoute){
    if(itemActivation){
      return (){
        Navigator.of(context).pushNamed(navigationRoute);
      };
    }else{
      return null;
    }
  }

  List<Widget> _createNavigationItems(){ 
    final List<Widget> items = [];
    for(int i = 0; i < _navItemsActivation.length; i++){
      items.add(
        ButtonWithIcon(
          name: itemsNames[i], 
          textColor: _navItemsColors[i]['text'], 
          icon: icons[i],
          iconColor: _navItemsColors[i]['icon'], 
          onTap: itemsFunctions[i]
        )
      );
    }
    return items;
  }
}