import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/images/images_bloc.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: unused_element
class FotosPorAgregarGroup extends StatelessWidget {
  FotosPorAgregarGroup();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (context, state) {
          return __LoadedFotosPorAgregar(images: state.currentPhotosToSet);
        },
      )
    );
  }
}

class __LoadedFotosPorAgregar extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<File> images;
  __LoadedFotosPorAgregar({
    @required this.images
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.11,
      padding: EdgeInsets.symmetric(vertical: _sizeUtils.xasisSobreYasis * 0.01),
      width: double.infinity,
      child: _createListView(),
    );
  }

  Widget _createListView(){
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemBuilder: (_, int index){
        return _createImageContainer(images[index]);
      },
      separatorBuilder: (_, int i){
        return SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02);
      },
      itemCount: images.length,
    );
  }

  Widget _createImageContainer(File image){
    return Container(
      child: Image.file(
        image,
        height: _sizeUtils.xasisSobreYasis * 0.085,
        width: _sizeUtils.xasisSobreYasis * 0.085,
        fit: BoxFit.cover
      ),
    );
  }
}