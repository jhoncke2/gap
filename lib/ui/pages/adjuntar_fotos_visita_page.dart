import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
import 'package:gap/ui/widgets/commented_images/commented_images_section.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/indexing/index_pagination.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;
import 'package:gap/ui/widgets/progress_indicator.dart';

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
        child: GestureDetector(
          child: SingleChildScrollView(
            child: BlocBuilder<CommentedImagesBloc, CommentedImagesState>(
              builder: (context, state) {
                if(state.isLoading)
                  return CustomProgressIndicator();
                else
                  return _createContentItems();
              },
            ),
          ), 
          onTap: (){
            FocusScope.of(_context).requestFocus(new FocusNode());
          }
        ),
      ),
    );
  }

  Widget _createContentItems(){
    return Column(
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        Header(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createBottomItems()
      ],
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createTopComponents(state),
              CommentedImagesPageOfIndex(),
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
          _createAdjuntarFotosButtonByCommImgsState(),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          _createTextoSecundario(state.chosenVisit.name),
        ],
      ),
    );
  }

  Widget _createAdjuntarFotosButtonByCommImgsState(){
    final CommentedImagesState commImgsState = BlocProvider.of<CommentedImagesBloc>(_context).state;
    if(commImgsState.dataType == CmmImgDataType.UNSENT)
      return _createAdjuntarFotosButton();
    else
      return Container(
        height: _sizeUtils.xasisSobreYasis * 0.05,
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
    PagesNavigationManager.endAdjuntarImages(_context);
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