
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/ui/widgets/current_images_to_set_dialog/fotos_por_agregar_group.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';

// ignore: must_be_immutable
class AdjuntarFotosDialog extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final ImagePicker _imagePicker = ImagePicker();
  ImagesBloc _imagesBloc;
  CommentedImagesBloc _commImagesWidgBloc;
  IndexBloc _indexBloc;
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
    _commImagesWidgBloc = BlocProvider.of<CommentedImagesBloc>(_context);
    _indexBloc = BlocProvider.of<IndexBloc>(_context);    
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
    final ImagesBloc imagesBloc = BlocProvider.of<ImagesBloc>(_context);
    final LoadPhoto loadPhotoEvent = LoadPhoto(photo: photo);
    imagesBloc.add(loadPhotoEvent);
  }

  Widget _createSubirArchivoButton(){
    return GeneralButton(
      text: 'Subir archivo',
      backgroundColor: Theme.of(_context).secondaryHeaderColor,
      onPressed: _onSubirArchivoPressed
    );
  }

  void _onSubirArchivoPressed(){
    //_addCurrentPhotosToCommentedImages();
    //_resetFotosPorAgregar();
    //Navigator.of(_context).pop();
    PagesNavigationManager.updateImgsToCommentedImgs();
    Navigator.of(_context).pop();
  }


  void _addCurrentPhotosToCommentedImages(){
    final AddImages addImagesEvent = AddImages(images: _imagesBloc.state.currentPhotosToSet, onEnd: _changeNPagesToIndex);
    _commImagesWidgBloc.add(addImagesEvent);
  }

  void _changeNPagesToIndex(){
    final CommentedImagesState commImgsState = _commImagesWidgBloc.state;
    final int newIndexNPages = commImgsState.nPaginasDeCommImages;
    final ChangeNPages changesNPagesEvent = ChangeNPages(nPages: newIndexNPages);
    _indexBloc.add(changesNPagesEvent);
  }

  void _resetFotosPorAgregar(){ 
    final ResetImages resetAllEvent = ResetImages();
    _imagesBloc.add(resetAllEvent);
  }
}