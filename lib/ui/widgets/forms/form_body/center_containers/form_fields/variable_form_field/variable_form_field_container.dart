import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class VariableFormFieldContainer extends StatelessWidget {
  
  final SizeUtils _sizeUtils = SizeUtils();
  final String title;
  final Widget child;
  BuildContext _context;

  VariableFormFieldContainer({
    Key key,
    @required this.title,
    @required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      child: Column(
        children: [
          _createTitle(),
          SizedBox(height: 7.5),
          child
        ],
      ),
    );
  }

  Widget _createTitle(){
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.subtitleSize,
        fontWeight: FontWeight.w400
      ),
    );
  }
}