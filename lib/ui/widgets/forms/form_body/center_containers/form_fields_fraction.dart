import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_field_widget_factory.dart';
class FormInputsFraction extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  IndexState _indexState;
  FormInputsFraction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    _unlockIndexIfFormFieldsAreCompleted();
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (_, IndexState state){
        _indexState = state;
        if(state.nPages > 0)
          return _createFormFieldsWithIndex();
        else
          return _createFormFieldsWithoutIndex();
      }
    );
  }

  Widget _createFormFieldsWithIndex(){
    return SingleChildScrollView(
      child: Container(
        height: _sizeUtils.xasisSobreYasis * 0.65,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _createFormFieldItemsByPage(),
        ),
      )
    );
  }

  void _unlockIndexIfFormFieldsAreCompleted(){
    ChosenFormManagerSingleton.chosenFormManager.updateIndexByFormFieldsChange();
  }

  Widget _createFormFieldsWithoutIndex(){
    return Container();
  }

  List<Widget> _createFormFieldItemsByPage(){
    final int currentPage = _indexState.currentIndexPage;
    final ChosenFormBloc cfBloc = BlocProvider.of<ChosenFormBloc>(_context);
    final List<CustomFormField> formFieldsByCurrentPage = cfBloc.state.getFormFieldsByIndex(currentPage);
    final List<Widget> formFieldWidgets = formFieldsByCurrentPage.map<Widget>(
      (cff) => FormFieldWidgetFactory.createFormFieldWidget(cff)
    ).toList();
    
    return formFieldWidgets;
  }
}