import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/ui/widgets/current_images_to_set_dialog/adjuntar_images_dialog.dart';
final SizeUtils _sizeUtils = SizeUtils();

Future<void> showAdjuntarFotosDialog(BuildContext context)async{
  await showDialog(
    useRootNavigator: false,
    context: context,
    barrierColor: Colors.black.withOpacity(0.0175),
    builder: (BuildContext context){
      return Dialog(
        child: AdjuntarFotosDialog(),
        shape: _createGeneralDialogBorder(context)
      );
    },
  );
}

Future showErrDialog(BuildContext context, String errorMsg)async{
  await showDialog(
    context: context,
    builder: (BuildContext context){
      return _GeneralDialog(errorMsg);
    }
  );
}

RoundedRectangleBorder _createGeneralDialogBorder(BuildContext context){
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045),
    side: BorderSide(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      width: 3
    )
  );
}

Future showTemporalDialog(String message)async{
  showBlockedDialog(CustomNavigatorImpl.navigatorKey.currentContext, message);
  await Future.delayed(Duration(milliseconds: 1500), (){
    CustomNavigatorImpl.navigatorKey.currentState.pop();
  });
}

Future showBlockedDialog(BuildContext context, String message)async{
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context){
      return _GeneralDialog(message);
    },
  );
}


class _GeneralDialog extends StatelessWidget{
  final String message;

  _GeneralDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: _sizeUtils.xasisSobreYasis * 0.225,
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(
            '$message',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 19
            ),
          ),
        ),
      ),
      shape: _createGeneralDialogBorder(context)
    );
  }
}