import 'package:flutter/cupertino.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/storage_managers/visits/visits_storage_manager.dart';

class VisitsSingleton extends ChangeNotifier{
  bool _visitsAreLoaded = false;
  List<VisitOld> _visits;
  ProcessStage _selectedStepInNav;
  List<VisitOld> _pendientesVisits;
  List<VisitOld> _realizadasVisits;
  int _indexOfChosenFilterItem;
  DateTime _filterDate;
  List<VisitOld> _visitsByFilterDate;
  VisitOld _chosenVisit;

  Future setVisits(List<VisitOld> visits)async{
    final List<VisitOld> pendientesVisits = [];
    final List<VisitOld> realizadasVisits = [];
    _setVisitsToPendientesAndRealizadas(visits, pendientesVisits, realizadasVisits);
    _visitsAreLoaded = true;
    _visits = visits;
    _pendientesVisits = pendientesVisits;
    _realizadasVisits = realizadasVisits;
    await VisitsStorageManager.setVisits(visits);
    notifyListeners();
  }

  void _setVisitsToPendientesAndRealizadas(List<VisitOld> visits, List<VisitOld> pendientesVisits, List<VisitOld> realizadasVisits){
    visits.forEach((VisitOld visit) {
      if(visit.stage == ProcessStage.Pendiente)
        pendientesVisits.add(visit);
      else if(visit.stage == ProcessStage.Realizada)
        realizadasVisits.add(visit);
    });
  }

  set changeSelectedStepInNav(ProcessStage newSelectedMenuStage){
    _selectedStepInNav = newSelectedMenuStage;
    notifyListeners();
  }

  void changeDateFilterItem(int filterItemIndex, DateTime filterDate){
    _indexOfChosenFilterItem = filterItemIndex;
    _filterDate = filterDate;
    final List<VisitOld> filterVisits = _getVisitsWithSameDateThanFilter(filterDate);
    _visitsByFilterDate = filterVisits;
    notifyListeners();
  }

  List<VisitOld> _getVisitsWithSameDateThanFilter(DateTime filterDate){
    final Iterable<VisitOld> filterVisits = currentShowedVisits.where(
      (VisitOld visit){
        final String visitDateString = visit.date.toString().split(' ')[0];
        final String filterDateString = filterDate.toString().split(' ')[0];
        return visitDateString == filterDateString;
      }
    );
    return filterVisits.toList();
  }

  void chooseVisit(VisitOld visit){
    _chosenVisit = visit;
    VisitsStorageManager.setChosenVisit(visit);
    notifyListeners();
  }

  void resetAllOfVisits(){
    _visitsAreLoaded = false;
    _visits = null;
    _selectedStepInNav = null;
    _pendientesVisits = null;
    _realizadasVisits = null;
    _chosenVisit = null;
    _indexOfChosenFilterItem = null;
    _filterDate = null;
    _visitsByFilterDate = null;
    notifyListeners();
  }

  void resetDateFilter(){
    _indexOfChosenFilterItem = null;
    _filterDate = null;
    _visitsByFilterDate = null;
    notifyListeners();
  }

  bool get visitsAreLoaded => _visitsAreLoaded;
  List<VisitOld> get visits => _visits;
  ProcessStage get selectedStepInNav => _selectedStepInNav;
  List<VisitOld> get pendientesVisits => _pendientesVisits;
  List<VisitOld> get realizadasVisits => _realizadasVisits;
  int get indexOfChosenFilterItem => _indexOfChosenFilterItem;
  DateTime get filterDate => _filterDate;
  List<VisitOld> get visitsByFilterDate => _visitsByFilterDate;
  VisitOld get chosenVisit => _chosenVisit;

  List<VisitOld> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == ProcessStage.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<VisitOld> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == ProcessStage.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == ProcessStage.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}