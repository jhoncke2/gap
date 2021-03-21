import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/page_title.dart';
class FormProcessMainContainer extends StatelessWidget {
  static final SizeUtils _sizeUtils = SizeUtils();
  final String formName;
  final Widget bottomChild;
  FormProcessMainContainer({Key key, @required this.formName, @required this.bottomChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: _createGeneralPadding(),
        color: Colors.grey.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PageTitle(title: formName, underlined: false, centerText: true),
            bottomChild
          ],
        )
      ),
    );
  }

  EdgeInsets _createGeneralPadding(){
    return EdgeInsets.only(
      top: _sizeUtils.xasisSobreYasis * 0.025,
      bottom: _sizeUtils.xasisSobreYasis * 0.045,
      left: _sizeUtils.xasisSobreYasis * 0.045,
      right: _sizeUtils.xasisSobreYasis * 0.045
    );
  }
}