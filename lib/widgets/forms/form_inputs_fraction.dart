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
      width: double.infinity,
      child: Column(
        children: inputsItems,
      ),
    );
  }

  List<Widget> _createInputsItems(){
    final List<Widget> inputsItems = [];
    for(int i = 0; i < 4; i++){
      inputsItems.add(_createFakeInput());
    }
    return inputsItems;
  }

  Widget _createFakeInput(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: _sizeUtils.xasisSobreYasis * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createInputName(),
          _createInputBox()
        ],
      ),
    );
  }

  Widget _createInputName(){
    return Text(
      'Input X',
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.subtitleSize
      ),
    );
  }

  Widget _createInputBox(){
    return TextField(
      decoration: InputDecoration( 
        isDense: true 
      ),
    );
  }
}