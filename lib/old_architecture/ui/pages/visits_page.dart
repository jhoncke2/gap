import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/old_architecture/ui/widgets/visits_date_filter.dart';
class VisitsPageOld extends StatefulWidget {
  static final String route = 'visits';
  @override
  _VisitsPageOldState createState() => _VisitsPageOldState();
}

class _VisitsPageOldState extends State<VisitsPageOld>{
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext context){
    _initInitialConfiguration(context);
    return Scaffold(
       body: NativeBackButtonLocker(
         child: SafeArea(
          child: Container(
            child: _createBodyComponents()
          ),
      ),
       ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createBodyComponents(){
    return Column(
      children: [
        SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
        PageHeader(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createVisitStateComponents()
      ],
    );
  }

  Widget _createVisitStateComponents(){
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.9,
      child: BlocBuilder<VisitsOldBloc, VisitsState>(
        builder: (_, VisitsState state){
          if(state.visitsAreLoaded){
            return _VisitsComponents(state: state);
          }else{
            return _createLoadingIndicator();
          }
        },
      ),
    );
  }

  Widget _createLoadingIndicator(){
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
    final VisitsOldBloc visitsBloc = BlocProvider.of<VisitsOldBloc>(_context);
    final ChangeSelectedStepInNav changeShVisitsStepEVent = ChangeSelectedStepInNav(newSelectedMenuStage: newSelectedStage);
    visitsBloc.add(changeShVisitsStepEVent);
    final ResetDateFilter resetDateFilterEvent= ResetDateFilter();
    visitsBloc.add(resetDateFilterEvent);
  }

  Widget _createNavigationList(VisitsState state){
    final List<VisitOld> visits = state.currentShowedVisits;
    return NavigationListWithStageButtons(itemsFunction: _onTapFunction, entitiesWithStages: visits, itemTileFunction: _createShowedItemTile);
  }

  Widget _createShowedItemTile(EntityWithStageOld visit){
    final String visitName = visit.name;
    final String visitDate = _getShowedItemStringDate(visit);
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            visitName,
            style: TextStyle(
              color: Theme.of(_context).primaryColor,
              fontSize: _sizeUtils.subtitleSize
            ),
          ),
          Text(
            visitDate,
            style: TextStyle(
              color: Theme.of(_context).primaryColor,
              fontSize: _sizeUtils.normalTextSize
            ),
          )
        ],
      ),
    );
  }

  String _getShowedItemStringDate(EntityWithStageOld visit){
    final DateTime visitDate = (visit as VisitOld).date;
    return '${visitDate.day}-${visitDate.month}-${visitDate.year}';
  }

  void _onTapFunction(EntityWithStageOld entity){
    PagesNavigationManager.navToVisitDetail(entity);
  }
}