import 'package:flutter/material.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/widgets/indexing/index_pagination.dart';
class FormIndex extends StatelessWidget {
  const FormIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IndexPagination(
        onChangePage: _onChangePage,
      ),
    );
  }

  Future _onChangePage()async{
    await PagesNavigationManager.updateFormFieldsPage();
  }
}