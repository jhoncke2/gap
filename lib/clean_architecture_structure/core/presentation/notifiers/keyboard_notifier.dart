import 'package:flutter/cupertino.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class KeyboardNotifier extends ChangeNotifier{
  Map<String, double> _sizePercentagesWithoutKeyboard;
  Map<String, double> _sizePercentagesWithKeyboard;
  bool _isActive;
  
  KeyboardNotifier(){
    _isActive = false;
    KeyboardVisibilityNotification().addNewListener(onChange: (bool isActive){
      _isActive = isActive;
      notifyListeners();
    });
  }
  
  set sizePercentagesWithoutKeyboard(Map<String, dynamic> sizePercentagesWithoutKeyboard){
    _sizePercentagesWithoutKeyboard = sizePercentagesWithoutKeyboard;
  }
  set sizePercentagesWithKeyboard(Map<String, dynamic> sizePercentagesWithKeyboard){
    _sizePercentagesWithKeyboard = sizePercentagesWithKeyboard;    
  }

  Map<String, dynamic> get sizePercentages => (_isActive)? 
    _sizePercentagesWithKeyboard
    : _sizePercentagesWithoutKeyboard;
}