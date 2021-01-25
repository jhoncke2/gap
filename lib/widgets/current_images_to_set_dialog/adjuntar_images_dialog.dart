import 'dart:io';
import 'package:gap/bloc/widgets/commented_images_widgets/commented_images_widgets_bloc.dart';
import 'package:gap/widgets/current_images_to_set_dialog/fotos_por_agregar_group.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/images/images_bloc.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/buttons/general_button.dart';

// ignore: must_be_immutable
class AdjuntarFotosDialog extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final ImagePicker _imagePicker = ImagePicker();
  ImagesBloc _imagesBloc;
  BuildContext _context;
  AdjuntarFotosDialog();

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
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
          FotosPorAgregarGroup(),
          _createSubirArchivoButton()
        ],
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _imagesBloc = BlocProvider.of<ImagesBloc>(_context);
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
       print('Ocurrió un error');
       print(err);
       Navigator.of(_context).pop();
     }
  }

  Future<void> _tryOnExaminarPressed()async{
    PickedFile pickedFile = await _imagePicker.getImage(
      source: ImageSource.gallery
    );
    final File photo = File(pickedFile.path);
    final ImagesBloc adjuntarImgsAVisitBloc = BlocProvider.of<ImagesBloc>(_context);
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
    _addCurrentTemporalPhotosToMainPhotos();
    _resetFotosPorAgregar();
    Navigator.of(_context).pop();
  }

  void _addCurrentTemporalPhotosToMainPhotos(){
    final List<File> photosToSet = _imagesBloc.state.currentPhotosToSet;
    final SetPhotos setPhotosEvent = SetPhotos(photos: photosToSet);
    final CommentedImagesWidgetsBloc commImagesWidgBloc = BlocProvider.of<CommentedImagesWidgetsBloc>(_context);
    //TODO: Verificar que no haya problemas de continuidad
    final AddImages addImagesEvent = AddImages(images: _imagesBloc.state.photos);
    commImagesWidgBloc.add(addImagesEvent);
    _imagesBloc.add(setPhotosEvent);
  }

  void _resetFotosPorAgregar(){
    
    final ResetAllImages resetAllEvent = ResetAllImages();
    _imagesBloc.add(resetAllEvent);
  }
}