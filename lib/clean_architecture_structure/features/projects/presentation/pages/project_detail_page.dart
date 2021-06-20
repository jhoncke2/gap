import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_app_scaffold.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import '../../../../injection_container.dart';

// ignore: must_be_immutable
class ProjectDetailPage extends StatelessWidget {
  static final route = 'project_detail';
  Project project;
  List<Function> onTapFunctions;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return GeneralAppScaffold(
      key: Key('project_detail'),
      providers: [
        BlocProvider<ProjectsBloc>(create: (_) => sl()),
      ],
      child: SafeArea(
        child: Container(child: _createBuilder()),
      ),
      createChild: () => SafeArea(
        child: Container(child: _createBuilder()),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext) {
    project = ModalRoute.of(appContext).settings.arguments;
    this.context = appContext;
    onTapFunctions = [() => PagesNavigationManager.navToVisits(), () {}];
  }

  Widget _createBuilder() {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (builderContext, state) {
        if (state is OnUnloadedProjects) {
          _loadChosenProject(builderContext);
        } else if (state is OnLoadingChosenProject)
          return _createLoadingProjectWidget();
        else if (state is OnLoadedChosenProject)
          return LoadedChosenProject();
        return _createLoadingProjectWidget();
      },
    );
  }

  void _loadChosenProject(BuildContext builderContext){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<ProjectsBloc>(builderContext)
          .add(LoadChosenProjectEvent());
    });
  }

  Widget _createLoadingProjectWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan[600],
          strokeWidth: 7.5,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoadedChosenProject extends StatelessWidget {
  static final SizeUtils _sizeUtils = SizeUtils();
  final List<String> itemsNames = ['Visitas', 'Viáticos'];
  BuildContext context;
  LoadedChosenProject({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        PageHeader(),
        SizedBox(height: _sizeUtils.largeSizedBoxHeigh),
        _createNavigationList()
      ],
    );
  }

  Widget _createNavigationList() {
    final NavigationState navigationState = BlocProvider.of<NavigationBloc>(context).state;
    if (navigationState is InactiveNavigation) {
      return NavigationList(
        itemsLength: itemsNames.length,
        createSingleNavButton: _createNavButton,
        horizontalPadding: 0.05,
      );
    } else {
      return Container();
    }
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

  Widget _createViaticosListButton(BuildContext context){
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