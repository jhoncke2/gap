import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/widgets/commented_images/commented_images_section.dart';
import 'package:gap/old_architecture/ui/widgets/header/page_header.dart';
import 'package:gap/old_architecture/ui/widgets/indexing/index_pagination.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;

// ignore: must_be_immutable
class AdjuntarFotosVisitaPageOld extends StatelessWidget {
  static final String route = 'adjuntar_fotos_visit';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  AdjuntarFotosVisitaPageOld();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: NativeBackButtonLocker(
        child: SafeArea(
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
      ),
    );
  }

  Widget _createContentItems(){
    return Column(
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        PageHeaderOld(),
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
      child: BlocBuilder<VisitsOldBloc, VisitsState>(
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
    return BlocBuilder<IndexOldBloc, IndexState>(
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
    final IndexOldBloc indexBloc = BlocProvider.of<IndexOldBloc>(_context);
    indexBloc.add(ResetAllOfIndex());
  }
}