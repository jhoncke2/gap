import 'package:flutter/material.dart';
import 'package:gap/logic/blocs_manager/pages_navigation_manager.dart';
import 'package:gap/ui/pages/visits_page.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list.dart';
// ignore: must_be_immutable
class ProjectDetailPage extends StatelessWidget {
  static final route = 'project_detail';  
  final List<String> itemsNames = ['Visitas', 'Viáticos'];
  List<Function> onTapFunctions;
  BuildContext _context;
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              Header(),
              SizedBox(height: _sizeUtils.largeSizedBoxHeigh),
              _createButtons()
            ],
          ),
        ),
      )
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    onTapFunctions = [
      () => PagesNavigationManager.navToVisits(_context),
      (){}
    ];
  }

  Widget _createButtons(){
    return NavigationList(
      itemsNames: itemsNames, 
      itemsFunctions: onTapFunctions,
      horizontalPadding: 0.05,
    );
  }
}

