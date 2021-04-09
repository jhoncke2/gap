import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/native_back_button_locker.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list.dart';

// ignore: must_be_immutable
class ProjectDetailPage extends StatelessWidget {
  static final route = 'project_detail';
  final List<String> itemsNames = ['Visitas', 'Viáticos'];
  List<Function> onTapFunctions;
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(body: SafeArea(
      child: NativeBackButtonLocker(
        child: Container(
          child: BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (context, state) {
              if(state.loadingProjects)
                return _createLoadingProjectsWidget();
              else
                return _createLoadedElements();
            },
          ),
        ),
      ),
    ));
  }

  void _initInitialConfiguration(BuildContext appContext) {
    _sizeUtils = SizeUtils();
    onTapFunctions = [() => PagesNavigationManager.navToVisits(), () {}];
  }

  Widget _createLoadingProjectsWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan[600],
          strokeWidth: 7.5,
        ),
      ),
    );
  }

  Widget _createLoadedElements(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        Header(),
        SizedBox(height: _sizeUtils.largeSizedBoxHeigh),
        _createNavigationList()
      ],
    );
  }

  Widget _createNavigationList() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 500)),
      builder: (_, __) {
        if (__.connectionState == ConnectionState.waiting) return Container();
        return NavigationList(
          itemsNames: itemsNames,
          itemsFunctions: onTapFunctions,
          horizontalPadding: 0.05,
        );
      },
    );
  }
}
