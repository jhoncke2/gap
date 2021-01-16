import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/models/visit.dart';
import 'package:gap/pages/visit_detail_page.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/navigation_list_button.dart';
import 'package:gap/widgets/visits_date_filter.dart';
import 'package:gap/utils/test/visits.dart' as fakeVisits;
class VisitsPage extends StatefulWidget {
  static final String route = 'visitas';
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final String _widgetTitle = 'Listado de visitas';
  BuildContext _context;
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext context){
    _initInitialConfiguration(context);
    _initFakeVisits();
    return Scaffold(
       body: SafeArea(
        child: Container(
          child: _createBodyComponents()
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  //Testing, mientras se implementan los VisitsManager
  void _initFakeVisits(){
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(_context);
    final List<Visit> visits = fakeVisits.visits;
    final SetVisits event = SetVisits(visits: visits);
    visitsBloc.add(event);
  }

  Widget _createBodyComponents(){
    return Column(
      children: [
        SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
        Header(withTitle: true, title: _widgetTitle),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createVisitStateComponents()
      ],
    );
  }

  Widget _createVisitStateComponents(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.05),
      height: _sizeUtils.xasisSobreYasis * 0.95,
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (_, VisitsState state){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createNavForVisitsStates(state),
              VisitsDateFilter(),
              _createVisitsComponent(state)
            ],
          );
        },
      ),
    );
  }

  Widget _createNavForVisitsStates(VisitsState state){
    final Map<String, Color> navItemsColors = _elegirNavItemsColoresSegunState(state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createVisitsByStepNavigationItems(VisitStep.Pendiente, 'Visitas pendientes', navItemsColors['pendientes']),
        _createVisitsByStepNavigationItems(VisitStep.Realizada, 'Visitas realizadas', navItemsColors['realizadas'])
      ],
    );
  }

  Widget _createVisitsByStepNavigationItems(VisitStep visitStep, String name, Color color){
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(      
          vertical: _sizeUtils.xasisSobreYasis * 0.03
        ),
        child: Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: _sizeUtils.subtitleSize
          ),
        ),
      ),
      onTap: ()=>_changeShowedVisitsState(visitStep),
    );
  }

  Map<String, Color> _elegirNavItemsColoresSegunState(VisitsState state){
    final Map<String, Color> colors = {};
    if(state.showedVisitsStep == VisitStep.Pendiente){
      colors['pendientes'] = Theme.of(_context).primaryColor;
      colors['realizadas'] = Theme.of(_context).primaryColor.withOpacity(0.5);
    }else{
      colors['realizadas'] = Theme.of(_context).primaryColor;
      colors['pendientes'] = Theme.of(_context).primaryColor.withOpacity(0.5);
    }
    return colors;
  }

  void _changeShowedVisitsState(VisitStep newStep){
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(_context);
    final ChangeShowedVisitsStep changeShVisitsStepEVent =ChangeShowedVisitsStep(newShowedVisitsSetp: newStep);
    visitsBloc.add(changeShVisitsStepEVent);
    final ResetDateFilter resetDateFilterEvent= ResetDateFilter();
    visitsBloc.add(resetDateFilterEvent);
  }

  Widget _createVisitsComponent(VisitsState state){
    final List<Widget> visitsItems = _createVisitsItems(state);
    return Expanded(
      child: ListView(
        children: visitsItems,
      ),
    );
  }

  List<Widget> _createVisitsItems(VisitsState state){
    //TODO: Hasta haber implementado el formato bloc y la conexión con el server
    final List<Visit> visits = state.currentShowedVisits;
    final List<Widget> items = visits.map<Widget>((Visit visit){
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.03),
        child: Row(
          children: [
            _createCircleForVisitStep(visit.step),
            SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
            _createVisitRightItem(visit),
          ],
        ),
      );
    }).toList();
    return items;
  }

  Widget _createVisitRightItem(Visit visit){
    return Expanded(
      child: NavigationListButton(
        name: visit.name, 
        hasBottomBorder: true, 
        onTap: (){
          final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(_context);
          final ChooseVisit chooseVisitEvent = ChooseVisit(chosenOne: visit);
          visitsBloc.add(chooseVisitEvent);
          Navigator.of(_context).pushNamed(VisitDetailPage.route);
        }
      )
    );
  }

  Widget _createCircleForVisitStep(VisitStep step){
    final Color circleColor = (step == VisitStep.Pendiente)? 
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