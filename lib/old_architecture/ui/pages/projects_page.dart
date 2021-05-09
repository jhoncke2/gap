import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/old_architecture/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/header/page_header.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/navigation_list.dart';

// ignore: must_be_immutable
class ProjectsPageOld extends StatelessWidget {
  static final String route = 'projects';
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: NativeBackButtonLocker(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: _sizeUtils.xasisSobreYasis * 0.00),
            child: _createBodyComponents()
          ),
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext) {
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createBodyComponents() {
    return Column(
      children: [
        SizedBox(height: _sizeUtils.veryMuchLargeSizedBoxHeigh),
        PageHeaderOld(showBackNavButton: false),
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
    return BlocBuilder<ProjectsOldBloc, ProjectsState>(
      builder: (context, state) {
        if(state.projectsAreLoaded){
          final List<ProjectOld> projects = state.projects??[];
          final Map<String, List<dynamic>> namesAndFunctions =_createProjectsItemsNamesAndFunctions(projects);
          return NavigationList(itemsNames: namesAndFunctions['names'],
            itemsFunctions: namesAndFunctions['functions'],
            horizontalPadding: 0.075,
          );
        }else{
          return Container();
        }
      },
    );
  }

  Map<String, List<dynamic>> _createProjectsItemsNamesAndFunctions(List<ProjectOld> projects) {
    final List<Function> functions = [];
    final List<String> names = [];
    final Map<String, List<dynamic>> namesAndFunctions = {};
    projects.forEach((ProjectOld project){
      names.add(project.nombre);
      functions.add((){
        //TODO: Arreglar
        PagesNavigationManager.navToProjectDetail(project);
      });
    });
    namesAndFunctions['names'] = names;
    namesAndFunctions['functions'] = functions;
    return namesAndFunctions;
  }
}