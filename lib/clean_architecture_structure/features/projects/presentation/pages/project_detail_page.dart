import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_native_back_button_locker.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import '../../../../injection_container.dart';

// ignore: must_be_immutable
class ProjectDetailPage extends StatelessWidget {
  static final route = 'project_detail';
  final List<String> itemsNames = ['Visitas', 'Viáticos'];
  Project project;
  List<Function> onTapFunctions;
  SizeUtils _sizeUtils;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return ScaffoldNativeBackButtonLocker(
        child: SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProjectsBloc>(create: (_) => sl()),
          BlocProvider<NavigationBloc>(create: (_) => sl()),
        ],
        child: Container(child: _createBuilder()),
      ),
    ));
  }

  void _initInitialConfiguration(BuildContext appContext) {
    project = ModalRoute.of(appContext).settings.arguments;
    this.context = appContext;
    _sizeUtils = SizeUtils();
    onTapFunctions = [() => PagesNavigationManager.navToVisits(), () {}];
  }

  Widget _createBuilder() {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (builderContext, state) {
        if (state is EmptyProjects) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            BlocProvider.of<ProjectsBloc>(builderContext)
                .add(LoadChosenProjectEvent());
          });
        } else if (state is LoadingChosenProject)
          return _createLoadingProjectsWidget();
        else if (state is LoadedChosenProject)
          return _createLoadedElements(state.project);
        return Container();
      },
    );
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

  Widget _createLoadedElements(Project project) {
    return BlocProvider<NavigationBloc>(
      create: (context) => sl(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          PageHeader(),
          SizedBox(height: _sizeUtils.largeSizedBoxHeigh),
          _createNavigationList()
        ],
      ),
    );
  }

  Widget _createNavigationList() {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        this.context = context;
        if (state is InactiveNavigation) {
          return NavigationList(
            itemsLength: itemsNames.length,
            createSingleNavButton: _createNavButton,
            horizontalPadding: 0.05,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _createNavButton(int index) {
    if (index == 0)
      return _createVisitsButton(context);
    else
      return _createViaticosListButton(context);
  }

  Widget _createVisitsButton(BuildContext context) {
    return _createButton(context, 'visitas', () {
      _navToPage(NavigationRoute.Visits);
    });
  }

  Widget _createViaticosListButton(BuildContext context) {
    return _createButton(context, 'viáticos', () {
      _navToPage(NavigationRoute.Visits);
    });
  }

  Widget _createButton(BuildContext context, String name, Function onTap) {
    return NavigationListButton(
        textColor: Theme.of(context).primaryColor,
        hasBottomBorder: true,
        child: Text(
          name,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: _sizeUtils.subtitleSize),
        ),
        onTap: onTap);
  }

  void _navToPage(NavigationRoute navRoute) {
    //TODO: Quitar con implementación de nuevo código
    //PagesNavigationManager.navToVisits();
    BlocProvider.of<NavigationBloc>(context)
        .add(NavigateToEvent(navigationRoute: navRoute));
    Navigator.of(context).pushReplacementNamed(navRoute.value);
  }
}
