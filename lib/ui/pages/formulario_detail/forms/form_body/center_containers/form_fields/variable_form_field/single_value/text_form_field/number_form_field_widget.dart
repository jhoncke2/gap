import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';

import '../../variable_form_field_container.dart';
import 'text_form_field_widget.dart';

// ignore: must_be_immutable
class NumberFormFieldWidget extends TextFormFieldWidget {
  
  final NumberFormField number;
  TextEditingController _textFieldController;

  NumberFormFieldWidget({Key key, @required this.number, bool avaible = true, int indexInPage, StreamController<int> onTappedController}):
    super(key: Key('${number.name}'), indexInPage: indexInPage, onTappedController: onTappedController, avaible: avaible){
      _createTextFieldController();
    }
  
  void _createTextFieldController(){
    final String text = (number.placeholder ?? number.value ?? '').toString();
    _textFieldController = TextEditingController(text: text);
    _textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: _textFieldController.text.length));
  }

  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  int currentValue;

  @override
  Widget build(BuildContext context){
    _context = context;
    return VariableFormFieldContainer(
      title: number.label,
      child: _createCounter(),
    );
  }

  Widget _createCounter(){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.5,
      height: _sizeUtils.xasisSobreYasis * 0.17,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _createCounterBox(),
          SizedBox(width: 10),
          _createCounterButtons()
        ],
      ),
    );
  }

  Widget _createCounterBox(){
    //widget._textFieldController.text = currentValue.toString();
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.3,
      child: TextFormField(
        enabled: super.avaible,
        key: Key('${number.name}_textfield'),
        controller: _textFieldController,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        onTap: super.onTap,
        decoration: _createInputDecoration(),
        textAlign: TextAlign.center,
      ),
    );
  }

  InputDecoration _createInputDecoration(){
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20)
      )
    );
  }

  void onChanged(String stringNewValue){
    int newValue;
    if(stringNewValue == ''){
      newValue = null;
    }else{
      int currentValue = int.parse(stringNewValue);
      newValue = _getValueBasedOnItIsBetweenLimits(currentValue);
    }
    number.value = newValue;
    _textFieldController.text = newValue == null? null : newValue.toString();
    PagesNavigationManager.updateFormFieldsPage();
    
  }

  bool _newNumberIsBetweenLimits(int newNumber){
    if( _newNumberIsMinorToMin(newNumber) || _newNumberIsMayorToMax(newNumber) )
      return false;
    return true;
  }

  int _getValueBasedOnItIsBetweenLimits(int value){
    if(_newNumberIsBetweenLimits(value))
      return value;
    else
      return _getNearestExtremePointToNewValue(value);
  }

  int _getNearestExtremePointToNewValue(int val){
    int min = number.min;
    int max = number.max;
    if(max == null)
      return min;
    else if(min == null)
      return max;
    final double distanceBetweenXAndMin = math.sqrt(math.pow(val-number.min, 2));
    final double distanceBetweenXAndMax = math.sqrt(math.pow(val-number.max, 2));
    if(distanceBetweenXAndMin < distanceBetweenXAndMax)
      return min;
    else
      return max;
  }

  bool _newNumberIsMinorToMin(int newNumber){
    return (number.min != null && newNumber < number.min);
  }

  bool _newNumberIsMayorToMax(int newNumber){
    return (number.max != null && newNumber > number.max);
  }

  Widget _createCounterButtons(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createCounterButton(Icons.add, _plus, Key('${number.name}_plus')),
        SizedBox(height: 5),
        _createCounterButton(Icons.remove, _subtract, Key('${number.name}_subtract'))
      ],
    );
  }

  Widget _createCounterButton(IconData icon, Function operation, Key key){
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.05,
      width: _sizeUtils.xasisSobreYasis * 0.05,
      child: RaisedButton(
        padding: EdgeInsets.zero,
        elevation: 0,
        key: key,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: Theme.of(_context).primaryColor.withOpacity(0.3),
        child: Icon(
          icon,
          size: _sizeUtils.littleIconSize
        ),
        onPressed: (this.avaible)? (){_onChangeByButtons(operation);} : null,
      ),
    );
  }

  int _plus(){
    return number.value + number.step;
  }

  int _subtract(){
    return number.value - number.step;
  }

  void _onChangeByButtons(Function operateNumberValue){
    currentValue = _obtainInitialNumberForCounterButtons(operateNumberValue);
    int newValue = _getValueBasedOnItIsBetweenLimits(currentValue);
    number.value = newValue;
    _textFieldController.text = newValue.toString();
    PagesNavigationManager.updateFormFieldsPage();
  }

  int _obtainInitialNumberForCounterButtons(Function operateNumberValue){
    int newNumber = number.value == null? 0 : operateNumberValue();
    return newNumber;
  }
}