import 'package:flutter/material.dart';
import 'package:gap/pages/visits_page.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/navigation_list_button.dart';
// ignore: must_be_immutable
class ProjectDetailPage extends StatelessWidget {
  static final route = 'project_detail';
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
    if(_sizeUtils.size == null)
      _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createButtons(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.05),
      child: Column(
        children: [
          NavigationListButton(
            name: 'Visitas',
            hasBottomBorder: true,
            onTap: () => VisitsPage.route,

          ),
          NavigationListButton(
            name: 'Viáticos',
            hasBottomBorder: false,
            onTap: (){},

          )
        ],
      ),
    );
  }
}

