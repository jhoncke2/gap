import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/page_title.dart';
class FormProcessMainContainer extends StatelessWidget {
  static final SizeUtils _sizeUtils = SizeUtils();
  final String formName;
  final Widget bottomChild;
  final MainAxisAlignment mainAxisAlignment;
  final double separerHeightPercent;
  FormProcessMainContainer({Key key, @required this.formName, @required this.bottomChild, this.mainAxisAlignment = MainAxisAlignment.spaceBetween, this.separerHeightPercent = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: _createGeneralPadding(),
        //color: Colors.grey.withOpacity(0.2),
        //color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: this.mainAxisAlignment,
          children: [
            PageTitle(title: formName, underlined: false, centerText: true),
            SizedBox(height: _sizeUtils.size.height * this.separerHeightPercent),
            bottomChild
          ],
        )
      ),
    );
  }

  EdgeInsets _createGeneralPadding(){
    return EdgeInsets.only(
      top: _sizeUtils.xasisSobreYasis * 0.025,
      bottom: _sizeUtils.xasisSobreYasis * 0.0125,
      left: _sizeUtils.xasisSobreYasis * 0.045,
      right: _sizeUtils.xasisSobreYasis * 0.045
    );
  }
}