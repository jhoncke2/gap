import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
class PageTitle extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final String title;
  final bool underlined;
  final bool centerText;
  PageTitle({
    @required this.title,
    this.underlined = true,
    this.centerText = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        title,
        textAlign: _defineAlign(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: _sizeUtils.titleSize,
          fontWeight: FontWeight.bold,
          decoration: (this.underlined)?TextDecoration.underline:null
        ),
      ),
    );
  }

  TextAlign _defineAlign(){
    if(this.centerText)
      return TextAlign.center;
    else
      return TextAlign.left;
  }
}