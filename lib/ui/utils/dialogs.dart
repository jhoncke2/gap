import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/current_images_to_set_dialog/adjuntar_images_dialog.dart';
final SizeUtils _sizeUtils = SizeUtils();

Future<void> showAdjuntarFotosDialog(BuildContext context)async{
  await showDialog(
    useRootNavigator: false,
    context: context,
    barrierColor: Colors.black.withOpacity(0.0175),
    child: Dialog(
      child: AdjuntarFotosDialog(),
      shape: _createGeneralDialogBorder(context)
    )
  );
}

Future showErrDialog(BuildContext context, String errorMsg)async{
  await showDialog(
    context: context,
    child: Dialog(
      child: Container(
        height: _sizeUtils.xasisSobreYasis * 0.225,
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(
            '$errorMsg',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 19
            ),
          ),
        ),
      ),
      shape: _createGeneralDialogBorder(context)
    )
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

// ignore: must_be_immutable
