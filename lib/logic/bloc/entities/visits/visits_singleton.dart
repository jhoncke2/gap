import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class VisitsSingleton extends ChangeNotifier{
  bool _visitsAreLoaded = false;
  List<OldVisit> _visits;
  ProcessStage _selectedStepInNav;
  List<OldVisit> _pendientesVisits;
  List<OldVisit> _realizadasVisits;
  int _indexOfChosenFilterItem;
  DateTime _filterDate;
  List<OldVisit> _visitsByFilterDate;
  OldVisit _chosenVisit;

  Future setVisits(List<OldVisit> visits)async{
    final List<OldVisit> pendientesVisits = [];
    final List<OldVisit> realizadasVisits = [];
    _setVisitsToPendientesAndRealizadas(visits, pendientesVisits, realizadasVisits);
    _visitsAreLoaded = true;
    _visits = visits;
    _pendientesVisits = pendientesVisits;
    _realizadasVisits = realizadasVisits;
    await VisitsStorageManager.setVisits(visits);
    notifyListeners();
  }

  void _setVisitsToPendientesAndRealizadas(List<OldVisit> visits, List<OldVisit> pendientesVisits, List<OldVisit> realizadasVisits){
    visits.forEach((OldVisit visit) {
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
    final List<OldVisit> filterVisits = _getVisitsWithSameDateThanFilter(filterDate);
    _visitsByFilterDate = filterVisits;
    notifyListeners();
  }

  List<OldVisit> _getVisitsWithSameDateThanFilter(DateTime filterDate){
    final Iterable<OldVisit> filterVisits = currentShowedVisits.where(
      (OldVisit visit){
        final String visitDateString = visit.date.toString().split(' ')[0];
        final String filterDateString = filterDate.toString().split(' ')[0];
        return visitDateString == filterDateString;
      }
    );
    return filterVisits.toList();
  }

  void chooseVisit(OldVisit visit){
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
  List<OldVisit> get visits => _visits;
  ProcessStage get selectedStepInNav => _selectedStepInNav;
  List<OldVisit> get pendientesVisits => _pendientesVisits;
  List<OldVisit> get realizadasVisits => _realizadasVisits;
  int get indexOfChosenFilterItem => _indexOfChosenFilterItem;
  DateTime get filterDate => _filterDate;
  List<OldVisit> get visitsByFilterDate => _visitsByFilterDate;
  OldVisit get chosenVisit => _chosenVisit;

  List<OldVisit> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == ProcessStage.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<OldVisit> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == ProcessStage.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == ProcessStage.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}