import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class FormInputsFraction extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  FormInputsFraction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    final List<Widget> inputsItems = _createInputsItems();
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.675,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: inputsItems,
      ),
    );
  }

  List<Widget> _createInputsItems(){
    final List<Widget> inputsItems = [];
    for(int i = 0; i < 4; i++){
      inputsItems.add(_createFakeInput(i));
    }
    return inputsItems;
  }

  Widget _createFakeInput(int itemIndex){
    return Container(
      width: double.infinity,
      //margin: EdgeInsets.only(bottom: _sizeUtils.xasisSobreYasis * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createInputName(itemIndex),
          SizedBox(height:  _sizeUtils.veryLittleSizedBoxHeigh),
          _createInputBox()
        ],
      ),
    );
  }

  Widget _createInputName(int itemIndex){
    return Text(
      'Input $itemIndex',
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.subtitleSize
      ),
    );
  }

  Widget _createInputBox(){
    return TextField(
      decoration: InputDecoration( 
        isDense: true ,
        border: _createInputBorder(),
        enabledBorder: _createInputBorder()
      ),
    );
  }

  InputBorder _createInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.065),
      borderSide: BorderSide(
        color: Theme.of(_context).primaryColor.withOpacity(0.525),
        width: 3.5
      )
    );
  }
}