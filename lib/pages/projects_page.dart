import 'package:flutter/material.dart';
import 'package:gap/pages/project_detail_page.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/navigation_list/navigation_list.dart';
import 'package:gap/utils/test/projects.dart' as testingProjects;

// ignore: must_be_immutable
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
    return Column(
      children: [
        SizedBox(height:_sizeUtils.veryMuchLargeSizedBoxHeigh),
        Header(showBackNavButton: false, withTitle: true, title: _widgetTitle),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createProjectsNavList()
      ],
    );
  }

  Widget _createProjectsNavList(){
    final List<Map<String, dynamic>> projects = testingProjects.projects;
    final Map<String, List<dynamic>> namesAndFunctions = _createProjectsItemsNamesAndFunctions(projects);
    return NavigationList(
      itemsNames: namesAndFunctions['names'], 
      itemsFunctions: namesAndFunctions['functions'],
      horizontalPadding: 0.075,
    );
  }

  Map<String, List<dynamic>> _createProjectsItemsNamesAndFunctions(List<Map<String, dynamic>> projects){
    final List<Function> functions = [];
    final List<String> names = [];
    final Map<String, List<dynamic>> namesAndFunctions = {};
    projects.forEach((Map<String, dynamic> project) {
      names.add(project['name']);
      functions.add(()=>Navigator.of(_context).pushNamed(ProjectDetailPage.route));
    });
    namesAndFunctions['names'] = names;
    namesAndFunctions['functions'] = functions;
    return namesAndFunctions;
  }
}