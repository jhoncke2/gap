import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/ui/utils/size_utils.dart';
class NumberFormFieldWidget extends StatefulWidget{
  
  final NumberFormField number;
  final TextEditingController _textFieldController;

  NumberFormFieldWidget({Key key, @required this.number}):
    _textFieldController = TextEditingController(text: number.placeholder),
    super(key: key)
    ;

  @override
  _NumberFormFieldWidgetState createState() => _NumberFormFieldWidgetState();
}

class _NumberFormFieldWidgetState extends State<NumberFormFieldWidget> {
  final SizeUtils _sizeUtils = SizeUtils();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.number.label
          ),
          SizedBox(height: 10),
          _createCounter()
        ],
      ),
    );
  }

  Widget _createCounter(){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.25,
      height: _sizeUtils.xasisSobreYasis * 0.17,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createCounterBox(),
          SizedBox(width: 5),
          _createCounterButtons()
        ],
      ),
    );
  }

  Widget _createCounterBox(){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.1,
      child: TextFormField(
        key: Key('${widget.number.name}_textfield'),
        controller: widget._textFieldController,
        //initialValue: _defineInitialValue(),
        keyboardType: TextInputType.number,
        onChanged: _onChanged,
      ),
    );
  }

  String _defineInitialValue(){
    if(widget.number.value != null)
      return widget.number.value.toString();
    else if(widget.number.placeholder != null)
      return widget.number.placeholder;
    return null;
  }

  void _onChanged(String newValue){
    final int newNum = int.parse(newValue);
    if(!_newNumberIsBetweenLimits(newNum))
      return;
    widget.number.value = newNum;
    widget._textFieldController.text = newValue;
  }

  bool _newNumberIsBetweenLimits(int newNumber){
    if( _newNumberIsMinorToMin(newNumber) || _newNumberIsMayorToMax(newNumber) )
      return false;
    return true;
  }

  bool _newNumberIsMinorToMin(int newNumber){
    return (widget.number.min != null && widget.number.min < newNumber);
  }

  bool _newNumberIsMayorToMax(int newNumber){
    return (widget.number.max != null && newNumber > widget.number.max);
  }

  Widget _createCounterButtons(){
    return Column(
      children: [
        _createCounterButton(Icons.add, _plus, Key('${widget.number.name}_plus')),
        _createCounterButton(Icons.remove, _subtract, Key('${widget.number.name}_subtract'))
      ],
    );
  }

  Widget _createCounterButton(IconData icon, Function operation, Key key){
    return MaterialButton(
      key: key,
      height: _sizeUtils.xasisSobreYasis * 0.01,
      minWidth: _sizeUtils.xasisSobreYasis * 0.02,
      child: Icon(
        icon,
        size: _sizeUtils.xasisSobreYasis * 0.03
      ),
      onPressed: (){_onChangeByButtons(operation);},
    );
  }

  int _plus(){
    return widget.number.value + widget.number.step;
  }

  int _subtract(){
    return widget.number.value - widget.number.step;
  }

  void _onChangeByButtons(Function operateNumberValue){
    int newNumber = _obtainInitialNumberForCounterButtons(operateNumberValue);
    _onChanged(newNumber.toString());
  }

  int _obtainInitialNumberForCounterButtons(Function operateNumberValue){
    int newNumber = widget.number.value == null? 0 : operateNumberValue();
    return newNumber;
  }
}