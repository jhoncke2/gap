import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_native_back_button_locker.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/widgets/loaded_projects.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class ProjectsPage extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  ProjectsPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return ScaffoldNativeBackButtonLocker(
      child: BlocProvider<ProjectsBloc>(
        create: (context) => sl(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _sizeUtils.xasisSobreYasis * 0.00
            ),
            child: _createBodyComponents(),
          ),
        ),
      ),
    );
  }

  Widget _createBodyComponents() {
    return Column(
      children: [
        SizedBox(height: _sizeUtils.veryMuchLargeSizedBoxHeigh),
        PageHeader(showBackNavButton: false),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createBottomComponents()
      ],
    );
  }

  Widget _createBottomComponents() {
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.75,
      padding: EdgeInsets.symmetric(
        horizontal: _sizeUtils.normalHorizontalScaffoldPadding
      ),
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
        _addPostFrameCall(context);
        if (state is LoadedProjects) {
          return LoadedProjectsWidget(projects: state.projects);
        }else if (state is LoadingProjects) {
          return CustomProgressIndicator(heightScreenPercentage: 0.4);
        }else {
          return Container();
        }
      },
    );
  }

  void _addPostFrameCall(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      BlocProvider.of<ProjectsBloc>(context).add( LoadProjects() );
    });
  }
}