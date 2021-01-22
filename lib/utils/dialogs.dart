import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/ui/adjuntar_imgs_a_visit/adjuntar_imgs_a_visit_bloc.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/buttons/general_button.dart';
import 'package:image_picker/image_picker.dart';
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
      child: _AdjuntarFotosDialog()
    )
  );
}

// ignore: must_be_immutable
class _AdjuntarFotosDialog extends StatelessWidget {
  final ImagePicker _imagePicker = ImagePicker();
  BuildContext _context;
  _AdjuntarFotosDialog();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      margin: EdgeInsets.zero,
      height: _sizeUtils.xasisSobreYasis * 0.45,
      width: _sizeUtils.xasisSobreYasis * 0.55,
      padding: EdgeInsets.symmetric(
        horizontal: _sizeUtils.xasisSobreYasis * 0.07,
        vertical: _sizeUtils.xasisSobreYasis * 0.0425
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createHeadComponents(),
          _createSubirArchivoButton()
        ],
      ),
    );
  }

  Widget _createHeadComponents(){
    return Container(
      child: Column(
        children: [
          _createTitle(),
          _createDivider(),
          _createExaminarButton()
        ],
      ),
    );
  }

  Widget _createTitle(){
    return Container(
      width: double.infinity,
      child: Text(
        'Adjuntar fotos',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Theme.of(_context).primaryColor,
          fontSize: _sizeUtils.subtitleSize
        ),
      ),
    );
  }

  Widget _createDivider(){
    return Divider(
      color: Colors.black54,
    );
  }

  Widget _createExaminarButton(){
    return GeneralButton(
      text: 'Examinar', 
      onPressed: _onExaminarPressed, 
      backgroundColor: Theme.of(_context).secondaryHeaderColor
    );
  }

  void _onExaminarPressed()async{
     try{
        await _tryOnExaminarPressed();
     }catch(err){
       Navigator.of(_context).pop();
     }
  }

  Future<void> _tryOnExaminarPressed()async{
    PickedFile pickedFile = await _imagePicker.getImage(
      source: ImageSource.gallery
    );
    final File photo = File(pickedFile.path);
    final AdjuntarImgsAVisitBloc adjuntarImgsAVisitBloc = BlocProvider.of<AdjuntarImgsAVisitBloc>(_context);
    final LoadPhoto loadPhotoEvent = LoadPhoto(photo: photo);
    adjuntarImgsAVisitBloc.add(loadPhotoEvent);
  }

  Widget _createSubirArchivoButton(){
    return GeneralButton(
      text: 'Subir archivo', 
      onPressed: _onSubirArchivoPressed, 
      backgroundColor: Theme.of(_context).secondaryHeaderColor
    );
  }

  void _onSubirArchivoPressed(){
    Navigator.of(_context).pop();
  }
}