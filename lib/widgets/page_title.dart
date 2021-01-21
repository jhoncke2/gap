import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
class PageTitle extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final String title;
  final bool underlined;
  PageTitle({
    @required this.title,
    this.underlined = true
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: _sizeUtils.titleSize,
        fontWeight: FontWeight.bold,
        decoration: (this.underlined)?TextDecoration.underline:null
      ),
    );
  }
}