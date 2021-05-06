import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class LoadedProjectsWidget extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<Project> projects;
  Map<String, List<dynamic>> namesAndFunctions;
  BuildContext context;
  LoadedProjectsWidget({Key key, @required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _createProjectsItemsNamesAndFunctions(projects);
    return NavigationList(
      itemsLength: namesAndFunctions.length,
      createSingleNavButton: _createSingleNavButton,
      horizontalPadding: 0.02,
    );
  }

  Widget _createSingleNavButton(int index) {
    return NavigationListButton(
      child: Text(
        namesAndFunctions['names'][index],
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: _sizeUtils.normalTextSize
        ),
      ),
      textColor: Theme.of(context).primaryColor,
      hasBottomBorder: true,
      onTap: namesAndFunctions['functions'][index]
    );
  }

  void _createProjectsItemsNamesAndFunctions(List<Project> projects) {
    namesAndFunctions = {};
    final List<Function> functions = [];
    final List<String> names = [];
    projects.forEach((Project project) {
      names.add(project.nombre);
      functions.add(() {});
    });
    namesAndFunctions['names'] = names;
    namesAndFunctions['functions'] = functions;
  }
}