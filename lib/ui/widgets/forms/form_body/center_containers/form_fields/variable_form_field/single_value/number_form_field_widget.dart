import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/variable_form_field_container.dart';
class NumberFormFieldWidget extends StatefulWidget{
  
  final NumberFormField number;
  final TextEditingController _textFieldController;

  NumberFormFieldWidget({Key key, @required this.number}):
    _textFieldController = TextEditingController(text: number.placeholder),
    super(key: Key('${number.name}')){
      _textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: _textFieldController.text.length));
    }
    

  @override
  _NumberFormFieldWidgetState createState() => _NumberFormFieldWidgetState();
}

class _NumberFormFieldWidgetState extends State<NumberFormFieldWidget> {

  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  int currentValue;

  @override
  void initState() {
    widget._textFieldController.addListener(_onControllerChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    _context = context;
    return VariableFormFieldContainer(
      title: widget.number.label,
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

  void _onControllerChange(){
    print('controller.text: ${widget._textFieldController.text}');
  }

  Widget _createCounterBox(){
    widget._textFieldController.text = currentValue.toString();
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.3,
      child: TextFormField(
        key: Key('${widget.number.name}_textfield'),
        controller: widget._textFieldController,
        keyboardType: TextInputType.number,
        onChanged: _onChanged,
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

  void _onChanged(String newValue){
    currentValue = int.parse(newValue);
    if(!_newNumberIsBetweenLimits(currentValue))
      return;
    widget.number.value = currentValue;
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createCounterButton(Icons.add, _plus, Key('${widget.number.name}_plus')),
        SizedBox(height: 5),
        _createCounterButton(Icons.remove, _subtract, Key('${widget.number.name}_subtract'))
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
        onPressed: (){_onChangeByButtons(operation);},
      ),
    );
  }

  int _plus(){
    return widget.number.value + widget.number.step;
  }

  int _subtract(){
    return widget.number.value - widget.number.step;
  }

  void _onChangeByButtons(Function operateNumberValue){
    currentValue = _obtainInitialNumberForCounterButtons(operateNumberValue);
    if(_newNumberIsBetweenLimits(currentValue)){
      widget.number.value = currentValue;
      widget._textFieldController.text = currentValue.toString();
    }
  }

  int _obtainInitialNumberForCounterButtons(Function operateNumberValue){
    int newNumber = widget.number.value == null? 0 : operateNumberValue();
    return newNumber;
  }
}