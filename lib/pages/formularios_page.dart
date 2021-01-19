import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/formularios/formularios_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/models/EntityWithStages.dart';
import 'package:gap/models/formulario.dart';
import 'package:gap/models/visit.dart';
import 'package:gap/pages/visit_detail_page.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/navigation_list/button/navigation_list_button.dart';
import 'package:gap/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_nav_items.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class FormulariosPage extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  Visit _visit;
  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(withTitle: true, title: _visit.name),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createDate(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createFormulariosComponent()
          ],
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    final VisitsBloc vBloc = BlocProvider.of<VisitsBloc>(appContext);
    _visit = vBloc.state.chosenVisit;
  }

  Widget _createDate(){
    return Container(
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Text(
        _visit.date.toString().split(' ')[0],
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: _sizeUtils.subtitleSize,
          color: Theme.of(_context).primaryColor
        ),
      ),
    );
  }

  Widget _createFormulariosComponent(){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.05),
        child: BlocBuilder<FormulariosBloc, FormulariosState>(
          builder: (_, state) {
            if(state.formsAreLoaded){
              return Column(
                children: [
                  _createNavigationList(state),
                ],
              );
            }else{
              return UnloadedNavItems();
            }
          },
        ),
      ),
    );
  }

  Widget _createNavigationList(FormulariosState state){
    final List<Formulario> forms = state.forms;
    return NavigationListWithStageButtons(itemsFunction: _onItemTap, entitiesWithStages: forms);
  }

  void _onItemTap(EntityWithStages entity){

  }

  Widget _createFormulariosNavigation(FormulariosState state){
    final List<Widget> visitsItems = _createFormulariosItems(state);
    return ListView(
      children: visitsItems,
    );
  }

  List<Widget> _createFormulariosItems(FormulariosState state){
    //TODO: Hasta haber implementado el formato bloc y la conexión con el server
    final List<Formulario> formularios = state.forms;
    final List<Widget> items = formularios.map<Widget>((Formulario formulario){
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.03),
        child: Row(
          children: [
            _createCircleForVisitStep(formulario.currentStage),
            SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
            _createVisitRightItem(formulario),
          ],
        ),
      );
    }).toList();
    return items;
  }

  Widget _createVisitRightItem(Formulario formulario){
    return Expanded(
      child: NavigationListButton(
        name: formulario.name,
        textColor: Theme.of(_context).primaryColor,
        hasBottomBorder: true, 
        onTap: (){
          final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(_context);
          Navigator.of(_context).pushNamed(VisitDetailPage.route);
        }
      )
    );
  }

  Widget _createCircleForVisitStep(ProcessStage step){
    final Color circleColor = (step == ProcessStage.Pendiente)?
      Color.fromRGBO(213, 199, 18, 1)
      : Color.fromRGBO(142, 180, 22, 1);
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.0175,
      height: _sizeUtils.xasisSobreYasis * 0.0175,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor
      ),
    );
  }
}