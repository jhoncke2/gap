import 'package:flutter/material.dart';
import 'package:gap/pages/project_detail_page.dart';
import 'package:gap/pages/visits_page.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/utils/test/projects.dart' as testingProjects;
import 'package:gap/widgets/navigation_list_button.dart';

class ProjectsPage extends StatelessWidget {
  static final String route = 'projects';
  final String _widgetTitle = 'Listado de proyectos';
  BuildContext _context;
  SizeUtils _sizeUtils;
  
  @override
  Widget build(BuildContext context){
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _sizeUtils.xasisSobreYasis * 0.8,
          padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.00),
          child: _createBodyComponents()
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createBodyComponents(){
    final List<Widget> projectsItems = _createProjectsItems();
    return Column(
      children: [
        SizedBox(height:_sizeUtils.veryMuchLargeSizedBoxHeigh),
        Header(showBackNavButton: false, withTitle: true, title: _widgetTitle),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.085),
            children: projectsItems,
          ),
        )
      ],
    );
  }

  List<Widget> _createProjectsItems(){
    final List<Map<String, dynamic>> projects = testingProjects.projects;
    final List<Widget> items = projects.map<Widget>((Map<String, dynamic> project){
      return NavigationListButton(
        name: project['name'], 
        hasBottomBorder: true, 
        onTap: ()=>Navigator.of(_context).pushNamed(ProjectDetailPage.route)
      );
    }).toList();
    return items;
  }
}