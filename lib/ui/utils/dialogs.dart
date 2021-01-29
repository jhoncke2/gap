import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/current_images_to_set_dialog/adjuntar_images_dialog.dart';
final SizeUtils _sizeUtils = SizeUtils();

Future<void> showAdjuntarFotosDialog(BuildContext context)async{
  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.0175),
    child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          width: 3
        )
      ),
      child: AdjuntarFotosDialog()
    )
  );
}

// ignore: must_be_immutable