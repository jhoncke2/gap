import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class VisitsSingleton extends ChangeNotifier{
  bool _visitsAreLoaded = false;
  List<Visit> _visits;
  ProcessStage _selectedStepInNav;
  List<Visit> _pendientesVisits;
  List<Visit> _realizadasVisits;
  int _indexOfChosenFilterItem;
  DateTime _filterDate;
  List<Visit> _visitsByFilterDate;
  Visit _chosenVisit;

  Future setVisits(List<Visit> visits)async{
    final List<Visit> pendientesVisits = [];
    final List<Visit> realizadasVisits = [];
    _setVisitsToPendientesAndRealizadas(visits, pendientesVisits, realizadasVisits);
    _visitsAreLoaded = true;
    _visits = visits;
    _pendientesVisits = pendientesVisits;
    _realizadasVisits = realizadasVisits;
    await VisitsStorageManager.setVisits(visits);
    notifyListeners();
  }

  void _setVisitsToPendientesAndRealizadas(List<Visit> visits, List<Visit> pendientesVisits, List<Visit> realizadasVisits){
    visits.forEach((Visit visit) {
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
    final List<Visit> filterVisits = _getVisitsWithSameDateThanFilter(filterDate);
    _visitsByFilterDate = filterVisits;
    notifyListeners();
  }

  List<Visit> _getVisitsWithSameDateThanFilter(DateTime filterDate){
    final Iterable<Visit> filterVisits = currentShowedVisits.where(
      (Visit visit){
        final String visitDateString = visit.date.toString().split(' ')[0];
        final String filterDateString = filterDate.toString().split(' ')[0];
        return visitDateString == filterDateString;
      }
    );
    return filterVisits.toList();
  }

  void chooseVisit(Visit visit){
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
  List<Visit> get visits => _visits;
  ProcessStage get selectedStepInNav => _selectedStepInNav;
  List<Visit> get pendientesVisits => _pendientesVisits;
  List<Visit> get realizadasVisits => _realizadasVisits;
  int get indexOfChosenFilterItem => _indexOfChosenFilterItem;
  DateTime get filterDate => _filterDate;
  List<Visit> get visitsByFilterDate => _visitsByFilterDate;
  Visit get chosenVisit => _chosenVisit;

  List<Visit> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == ProcessStage.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<Visit> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == ProcessStage.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == ProcessStage.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}