import 'package:flutter/cupertino.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';

class VisitsChangeNotifier extends ChangeNotifier{
  List<Visit> _totalVisits;
  List<Visit> _currentShowedVisits;
  int _currentSelectedVisitType;
  int _selectedDateMenuIndex;
  DateTime _selectedDate;

  VisitsChangeNotifier(){
    _currentSelectedVisitType = 0;
    _currentShowedVisits = [];
  }

  set totalVisits(List<Visit> totalVisits){
    _totalVisits = totalVisits;
    currentSelectedVisitType = 0;
  }

  set currentSelectedVisitType(int newVisitType){
    this._currentSelectedVisitType = newVisitType;
    bool completo = newVisitType == 1;
    _currentShowedVisits = _totalVisits.where((v) => v.completo == completo).toList();
    this._selectedDateMenuIndex = null;
    notifyListeners();
  }

  void setCurrentSelectedDateFilter(int dateFilter, DateTime dateTime){
    this._selectedDateMenuIndex = dateFilter;
    _currentShowedVisits = _totalVisits.where(
      (v) => v.date.year == dateTime.year
          && v.date.month == dateTime.month
          && v.date.day == dateTime.day
    ).toList();
    notifyListeners();
  }

  List<Visit> get currentShowedVisits => _currentShowedVisits;
  int get currentSelectedVisitType => _currentSelectedVisitType;
  int get selectedDateMenuIndex => _selectedDateMenuIndex;
  DateTime get selectedDate => _selectedDate;
}