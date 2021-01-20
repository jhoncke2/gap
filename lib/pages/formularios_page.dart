import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/formularios/formularios_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/pages/formulario_detail_page.dart';
import 'package:gap/widgets/header/header.dart';
import 'package:gap/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/widgets/page_title.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_nav_items.dart';
import 'package:gap/models/EntityWithStages.dart';
import 'package:gap/models/formulario.dart';
import 'package:gap/models/visit.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class FormulariosPage extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  Visit _visit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
            Header(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createFormulariosComponent()
          ],
        ),
      ),
    );
  }

  Widget _createFormulariosComponent(){
    return BlocBuilder<FormulariosBloc, FormulariosState>(
      builder: (_, state) {
        if(state.formsAreLoaded){
          return _FormulariosComponents(visitForms: state.forms);
        }else{
          return UnloadedNavItems();
        }
      },
    );
  }
}



// ignore: must_be_immutable
class _FormulariosComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<Formulario> visitForms;
  Visit visit;
  BuildContext _context;
  _FormulariosComponents({
    @required this.visitForms
  });

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.75,
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: this.visit.name, underlined: false),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createDate(),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createNavigationList(),
        ],
      )
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    final VisitsBloc vBloc = BlocProvider.of<VisitsBloc>(appContext);
    this.visit = vBloc.state.chosenVisit;
  }

  Widget _createDate(){
    return Container(
      
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Text(
        visit.date.toString().split(' ')[0],
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: _sizeUtils.subtitleSize,
          color: Theme.of(_context).primaryColor
        ),
      ),
    );
  }

  Widget _createNavigationList( ){
    final List<Formulario> forms = visitForms;
    return NavigationListWithStageButtons(itemsFunction: _onItemTap, entitiesWithStages: forms);
  }

  void _onItemTap(EntityWithStages entity){
    final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(_context);
    final ChooseForm chooseFormEvent = ChooseForm(chosenOne: entity);
    formsBloc.add(chooseFormEvent);
    Navigator.of(_context).pushNamed(FormularioDetailPage.route);
  }
}