import 'package:flutter/material.dart';
class HeaderLineDivider extends StatelessWidget {
  const HeaderLineDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _createHeaderDividerLine(Colors.black87),
        _createHeaderDividerLine(Colors.pink),
      ],
    );
  }

  Widget _createHeaderDividerLine(Color color){
    return Divider(
      color: color,
      thickness: 3,
      height: 3,
    );
  }
}