import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/blocs_manager/pages_navigation_manager.dart';
import 'package:gap/ui/pages/visit_detail_page.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';
import 'package:gap/ui/widgets/visits_date_filter.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
class VisitsPage extends StatefulWidget {
  static final String route = 'visits';
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
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
    final List<OldVisit> visits = fakeData.visits;
    final SetVisits event = SetVisits(visits: visits);
    visitsBloc.add(event);
  }

  Widget _createBodyComponents(){
    return Column(
      children: [
        SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
        Header(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createVisitStateComponents()
      ],
    );
  }

  Widget _createVisitStateComponents(){
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.75,
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (_, VisitsState state){
          if(state.visitsAreLoaded){
            return _VisitsComponents(state: state);
          }else{
            return UnloadedNavItems();
          }
        },
      ),
    );
  }
}


// ignore: must_be_immutable
class _VisitsComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final VisitsState state;
  BuildContext _context;
  _VisitsComponents({
    @required this.state
  });

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _sizeUtils.normalHorizontalScaffoldPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: 'Listado de visitas'),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createNavForVisitsStates(state),
          VisitsDateFilter(),
          _createNavigationList(state)
        ],
      )
    );

  }

  Widget _createNavForVisitsStates(VisitsState state){
    final Map<String, Color> navItemsColors = _elegirNavItemsColoresSegunState(state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createVisitsByStageNavigationItems(ProcessStage.Pendiente, 'Visitas pendientes', navItemsColors['pendientes']),
        _createVisitsByStageNavigationItems(ProcessStage.Realizada, 'Visitas realizadas', navItemsColors['realizadas'])
      ],
    );
  }

  Map<String, Color> _elegirNavItemsColoresSegunState(VisitsState state){
    final Map<String, Color> colors = {};
    if(state.selectedStepInNav == ProcessStage.Pendiente){
      colors['pendientes'] = Theme.of(_context).primaryColor;
      colors['realizadas'] = Theme.of(_context).primaryColor.withOpacity(0.5);
    }else{
      colors['realizadas'] = Theme.of(_context).primaryColor;
      colors['pendientes'] = Theme.of(_context).primaryColor.withOpacity(0.5);
    }
    return colors;
  }

  Widget _createVisitsByStageNavigationItems(ProcessStage visitsStage, String name, Color color){
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
      onTap: ()=>_changeShowedVisitsState(visitsStage),
    );
  }

  void _changeShowedVisitsState(ProcessStage newSelectedStage){
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(_context);
    final ChangeSelectedStepInNav changeShVisitsStepEVent =ChangeSelectedStepInNav(newSelectedMenuStage: newSelectedStage);
    visitsBloc.add(changeShVisitsStepEVent);
    final ResetDateFilter resetDateFilterEvent= ResetDateFilter();
    visitsBloc.add(resetDateFilterEvent);
  }

  Widget _createNavigationList(VisitsState state){
    final List<OldVisit> visits = state.currentShowedVisits;
    return NavigationListWithStageButtons(itemsFunction: _onTapFunction, entitiesWithStages: visits);
  }

  void _onTapFunction(EntityWithStage entity){
    PagesNavigationManager.navToVisitDetail(entity);
    //_choseVisit(entity);
    //_loadForms();
  }

  void _choseVisit(EntityWithStage entity){
    final OldVisit visit = entity as OldVisit;
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(_context);
    final ChooseVisit chooseVisitEvent = ChooseVisit(chosenOne: visit);
    visitsBloc.add(chooseVisitEvent);
  }

  void _loadForms(){
    final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(_context);
    final SetForms setFormsEvent = SetForms(forms: fakeData.formularios);
    formsBloc.add(setFormsEvent);
  }


}