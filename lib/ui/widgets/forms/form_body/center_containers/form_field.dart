import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final String fieldName;
  final Function onFieldChanged;
  BuildContext _context;

  CustomFormField({
    Key key,
    @required this.fieldName,
    @required this.onFieldChanged
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createInputName(),
          SizedBox(height:  _sizeUtils.veryLittleSizedBoxHeigh),
          _createInputBox()
        ],
      ),
    );
  }

   Widget _createInputName(){
    return Text(
      this.fieldName,
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.subtitleSize
      ),
    );
  }

  Widget _createInputBox(){
    return TextField(
      decoration: InputDecoration( 
        isDense: true,
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