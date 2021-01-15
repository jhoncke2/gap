import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/models/visit.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header.dart';
import 'package:gap/widgets/visits_date_filter.dart';
class VisitasPage extends StatefulWidget {
  static final String route = 'visitas';
  @override
  _VisitasPageState createState() => _VisitasPageState();
}

class _VisitasPageState extends State<VisitasPage> {
  final String _widgetTitle = 'Listado de visitas';
  BuildContext _context;
  SizeUtils _sizeUtils;
  @override
  Widget build(BuildContext context){
    _initInitialConfiguration(context);
    return Scaffold(
       body: SafeArea(
        child: Container(
          height: _sizeUtils.xasisSobreYasis * 0.8,
          padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.00),
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

  Widget _createBodyComponents(){
    return Column(
      children: [
        SizedBox(height:_sizeUtils.veryMuchLargeSizedBoxHeigh),
        Header(showBackNavButton: false, withTitle: true, title: _widgetTitle),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createVisitStateComponents()
      ],
    );
  }

  Widget _createVisitStateComponents(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.05),
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (_, VisitsState state){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createNavForVisitsStates(state),
              VisitsDateFilter()
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
            fontSize: _sizeUtils.normalTextSize
          ),
        ),
      ),
      onTap: ()=>_changeShowedVisitsState(visitStep),
    );
  }

  Map<String, Color> _elegirNavItemsColoresSegunState(VisitsState state){
    final Map<String, Color> colors = {};
    if(state.currentShowedVisitsStep == VisitStep.Pendiente){
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
    final ChangeShowedVisitsStep event =ChangeShowedVisitsStep(newShowedVisitsSetp: newStep);
    visitsBloc.add(event); 
  }
}