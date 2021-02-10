import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/ui/pages/visit_detail_page.dart';
import 'package:gap/ui/pages/visits_page.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/commented_images/commented_images_section.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/indexing/index_pagination.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

// ignore: must_be_immutable
class AdjuntarFotosVisitaPage extends StatelessWidget {
  static final String route = 'adjuntar_fotos_visit';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  AdjuntarFotosVisitaPage();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              Header(),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createBottomItems()
            ],
          ),
        ),
      ),
    );
  }

  Widget _createBottomItems() {
    return Container(
      width: MediaQuery.of(_context).size.width,
      height: _sizeUtils.xasisSobreYasis * 1.0,
      padding: EdgeInsets.symmetric(
      horizontal: _sizeUtils.normalHorizontalScaffoldPadding),
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createTopComponents(state),
              CommentedImagesPag(),
              IndexPagination(),
              _createEndButton()
            ],
          );
        },
      ),
    );
  }

  Widget _createTopComponents(VisitsState state){
    return Container(
      child: Column(
        children: [
          PageTitle(title: 'Adjuntar fotos', underlined: false),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          _createAdjuntarFotosButton(),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          _createTextoSecundario(state.chosenVisit.name),
        ],
      ),
    );
  }

  Widget _createAdjuntarFotosButton(){
    return GeneralButton(
      text: 'Adjuntar fotos a visita', 
      onPressed: _onAdjuntarPressed, 
      backgroundColor: Theme.of(_context).secondaryHeaderColor,
      borderShape: BtnBorderShape.Circular,
    );
  }

  void _onAdjuntarPressed(){
    dialogs.showAdjuntarFotosDialog(_context);
  }

  Widget _createTextoSecundario(String visitName){
    return Text(
      'Fotos adjuntadas a la visita: $visitName',
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.normalTextSize
      ),
    );
  }

  _createEndButton(){
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, IndexState state) {
        final bool estaEnUltimoIndexPage = _estaEnUltimoIndexPage(state);
        if(estaEnUltimoIndexPage){
          return _EndButton();
        }else{
          return Container(
            height: _sizeUtils.xasisSobreYasis * 0.0775,
          );
        }
      },
    );
  }

  bool _estaEnUltimoIndexPage(IndexState state){
    final int currentIndex = state.currentIndexPage;
    final int nPages = state.nPages;
    return currentIndex == nPages - 1;
  }
}

// ignore: must_be_immutable
class _EndButton extends StatelessWidget {
  BuildContext _context;
  Function _onPressed;
  _EndButton();

  @override
  Widget build(BuildContext context) {
    _createOnPressedFunction();
    _context = context;
    return Container(
      child: GeneralButton(
        text: 'Finalizar',
        backgroundColor: Theme.of(_context).secondaryHeaderColor,
        onPressed: _onPressed,
      ),
    );
  }

  void _createOnPressedFunction(){
    final bool allCommImgsAreCompleted = CommentedImagesIndexManagerSingleton.commImgIndexManager.allCommentedImagesAreCompleted();
    if(allCommImgsAreCompleted){
      _onPressed = _endImgsEdition;
    }else{
      _onPressed = null;
    }
  }

  void _endImgsEdition(){
    _resetCommImgsBloc();
    _resetIndexBloc();
    //TODO: llamar a servicio de enviar commentedImages al back
    Navigator.of(_context).pushReplacementNamed(VisitDetailPage.route);
  }

  void _resetCommImgsBloc(){
    final CommentedImagesBloc commImgsBloc = BlocProvider.of<CommentedImagesBloc>(_context);
    commImgsBloc.add(ResetCommentedImages());
  }

  void _resetIndexBloc(){
    final IndexBloc indexBloc = BlocProvider.of<IndexBloc>(_context);
    indexBloc.add(ResetAllOfIndex());
  }
}