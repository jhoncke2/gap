import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/entity_with_stage.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/button_with_stage_color.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/notifier/visits_change_notifier.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:provider/provider.dart';
import 'date_filter.dart';

// ignore: must_be_immutable
class LoadedVisits extends StatelessWidget {

  final SizeUtils _sizeUtils = SizeUtils();
  final List<Visit> visits;
  List<Visit> completedVisits;
  List<Visit> unCompleteVisits;
  VisitsChangeNotifier visitsChangeNotifier;
  BuildContext _context;

  LoadedVisits({
    @required this.visits
  }){
    completedVisits = [];
    unCompleteVisits = [];
    visits.forEach((v){
      if(v.completo)
        completedVisits.add(v);
      else
        unCompleteVisits.add(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _sizeUtils.normalHorizontalScaffoldPadding,
      ),
      child: ChangeNotifierProvider<VisitsChangeNotifier>(
        create: (_)=>sl()..totalVisits = visits,
        builder: (context, _){
          _context = context;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(title: 'Listado de visitas'),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createNavForVisitsStates(),
              DateFilter(),
              _createNavigationList()
            ],
          );
        },
      )
    );
  }

  Widget _createNavForVisitsStates(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createVisitsByStageNavigationItems('Visitas pendientes', 0),
        _createVisitsByStageNavigationItems('Visitas realizadas', 1)
      ],
    );
  }

  Widget _createVisitsByStageNavigationItems(String name, int buttonIndex){
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(      
          vertical: _sizeUtils.xasisSobreYasis * 0.03
        ),
        child: Text(
          name,
          style: TextStyle(
            color: _getTextColorByButtonIndex(buttonIndex),
            fontSize: _sizeUtils.subtitleSize
          ),
        ),
      ),
      onTap: ()=>_changeShowedVisitsState(buttonIndex),
    );
  }

  Color _getTextColorByButtonIndex(int buttonIndex){
    return (buttonIndex == Provider.of<VisitsChangeNotifier>(_context).currentSelectedVisitType)?
      Theme.of(_context).primaryColor
      : Theme.of(_context).primaryColor.withOpacity(0.5);
  }

  void _changeShowedVisitsState(int buttonIndex){
    Provider.of<VisitsChangeNotifier>(_context, listen: false).currentSelectedVisitType = buttonIndex;
  }

  Widget _createNavigationList(){
    final List<Visit> visits = Provider.of<VisitsChangeNotifier>(_context).currentShowedVisits;
    return NavigationList(
      itemsLength: visits.length,
      createSingleNavButton: _createVisitButton,
    );
    return NavigationListWithStageColorButtons(
      entitiesWithStages: visits,
      itemsFunction: _onTapVisit,
    );
  }

  dynamic _onTapVisit(EntityWithStage visit){
    //TODO: Quitarlo al implementar clean architecture en siguiente vista
    PagesNavigationManager.navToVisitDetail(VisitOld.fromNewVisit(visit));
  }

  Widget _createVisitButton(int index){
    final Visit visit = visits[index];
    return ButtonWithStageColor(
      textColor: Theme.of(_context).primaryColor, 
      onTap: (){}, 
      stage: visit.stage,
      rightChild: _createShowedItemTile(visit),
    );
  }

  Widget _createShowedItemTile(Visit visit){
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

  String _getShowedItemStringDate(Visit visit){
    final DateTime visitDate = visit.date;
    return '${visitDate.day}-${visitDate.month}-${visitDate.year}';
  }
}