import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/models/visit.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/navigation_list_button.dart';

class VisitDetailPage extends StatelessWidget {
  static final String route = 'visit_detail';
  final List<Map<String, dynamic>> _navigationItemsParts = [
    {
      'icon':Icons.arrow_right_alt_outlined,
      'name':'Iniciar visita'
    },
    {
      'icon': Icons.attach_file,
      'name':'Adjuntar fotos'
    },
    {
      'icon': Icons.remove_red_eye_outlined,
      'name':'Visualizar visita'
    }
  ];
  BuildContext _context;
  SizeUtils _sizeUtils;
  Visit _visit;
  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: Container(child: _createBodyComponents()),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              Header(withTitle: true, title: _visit.name),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createDateText(),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createNavigationComponent(state)
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

  Widget _createNavigationComponent(VisitsState state){
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
    final List<Visit> visits = state.currentShowedVisits;
    final List<Widget> items = [];
    for(int i = 0; i < _navigationItemsParts.length; i++){
      final Map<String, dynamic> navItemParts = _navigationItemsParts[i];
      items.add(
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.03),
          child: Row(
            children: [
              _createNavItemIcon(navItemParts['icon']),
              SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
              _createNavItemName(navItemParts['name']),
            ],
          ),
        )
      );
    }
    return items;
  }

  Widget _createNavItemName(String name){
    return Expanded(
      child: NavigationListButton(
        name: name, 
        hasBottomBorder: false, 
        onTap: (){}
      )
    );
  }

  Widget _createNavItemIcon(IconData icon){
    return Icon(
      icon,
      size: _sizeUtils.largeIconSize,
      color: Color.fromRGBO(213, 199, 18, 1),
    );
  }
}
