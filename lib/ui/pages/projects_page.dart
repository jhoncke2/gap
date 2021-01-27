import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/models/entities/project.dart';
import 'package:gap/ui/pages/project_detail_page.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';

// ignore: must_be_immutable
class ProjectsPage extends StatelessWidget {
  static final String route = 'projects';
  BuildContext _context;
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: _sizeUtils.xasisSobreYasis * 0.00),
          child: _createBodyComponents()
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext) {
    _context = appContext;
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createBodyComponents() {
    return Column(
      children: [
        SizedBox(height: _sizeUtils.veryMuchLargeSizedBoxHeigh),
        Header(showBackNavButton: false),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createBottomComponents()
      ],
    );
  }

  Widget _createBottomComponents(){
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.75,
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.normalHorizontalScaffoldPadding),
      child: Column(
        children: [
          PageTitle(title: 'Listado de proyectos'),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createProjectsNavList()
        ],
      ),
    );
  }

  Widget _createProjectsNavList() {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if(state.projectsAreLoaded){
          final List<Project> projects = state.projects;
          final Map<String, List<dynamic>> namesAndFunctions =_createProjectsItemsNamesAndFunctions(projects);
          return NavigationList(
            itemsNames: namesAndFunctions['names'],
            itemsFunctions: namesAndFunctions['functions'],
            horizontalPadding: 0.075,
          );
        }else{
          return UnloadedNavItems();
        }
      },
    );
  }

  Map<String, List<dynamic>> _createProjectsItemsNamesAndFunctions(List<Project> projects) {
    final List<Function> functions = [];
    final List<String> names = [];
    final Map<String, List<dynamic>> namesAndFunctions = {};
    projects.forEach((Project project){
      names.add(project.name);
      functions.add((){
        _onChooseProject(project);
      });
    });
    namesAndFunctions['names'] = names;
    namesAndFunctions['functions'] = functions;
    return namesAndFunctions;
  }

  void _onChooseProject(Project project){
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(_context);
    final ChooseProject chooseProjEvent = ChooseProject(chosenOne: project);
    projectsBloc.add(chooseProjEvent);
    Navigator.of(_context).pushNamed(ProjectDetailPage.route);
  }
}
