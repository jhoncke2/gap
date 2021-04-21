import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/unloaded_elements/unloaded_form_inputs_index.dart';

class IndexPagination extends StatelessWidget {
  IndexPagination();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, IndexState state) {
        if(state.nPages > 0){
          return _LoadedIndexPagination(state: state);
        }else{
          return UnloadedIndexPagination();
        }
      },
    );
  }
}


// ignore: must_be_immutable
class _LoadedIndexPagination extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final IndexState state;
  final int _nPages;
  final int _currentIndex;
  final bool _sePuedeAvanzar;
  final bool _sePuedeRetroceder;

  BuildContext _context;
  IndexBloc _indexBloc;
  MainAxisAlignment _centralItemsMainAxisAlignment;
  List<Widget> _centralItems;

  _LoadedIndexPagination({
    @required this.state
  }):
    _nPages = state.nPages,
    _currentIndex = state.currentIndexPage,
    _sePuedeAvanzar = state.sePuedeAvanzar,
    _sePuedeRetroceder = state.sePuedeRetroceder
    ;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.0375,
      width: _sizeUtils.xasisSobreYasis * 0.4875,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createButtonsItems(),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _indexBloc = BlocProvider.of<IndexBloc>(_context);
  }

  List<Widget> _createButtonsItems(){
    final List<Widget> items = [];
    items.add( _createIndexTextButton('Anterior') );
    _defineCentralItemsConfiguration();
    items.add( _createCentralItemsContainer() );
    items.add( _createIndexTextButton('Siguiente') );
    return items;
  }

  Widget _createCentralItemsContainer(){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.2,
      child: Row(
        children: _centralItems,
        mainAxisAlignment: _centralItemsMainAxisAlignment,
      ),
    );
  }

  void _defineCentralItemsConfiguration(){
    if(_nPages == 1){
      _definirSpecificCentralItemsConfiguration(_createOneInitialItem, MainAxisAlignment.center);
    }else if(_nPages == 2){
      _definirSpecificCentralItemsConfiguration(_createTwoInitialItems, MainAxisAlignment.spaceAround);
    }else if(_nPages == 3){
      _definirSpecificCentralItemsConfiguration(_createThreeInitialItems, MainAxisAlignment.spaceBetween);
    }else{
      _definirSpecificCentralItemsConfiguration(_createNItems, MainAxisAlignment.spaceBetween);
    }
  }

  void _definirSpecificCentralItemsConfiguration(Function definirCentralItems, MainAxisAlignment centrItemsMainAxAlignment){
    _centralItems = definirCentralItems();
    _centralItemsMainAxisAlignment = centrItemsMainAxAlignment;
  }

  List<Widget> _createOneInitialItem(){
    final List<Widget> items = _createNAnyButtons(0, 1);
    return items;
  }

  List<Widget> _createTwoInitialItems(){
    final List<Widget> items = _createNAnyButtons(0, 2);
    return items;
  }

  List<Widget> _createThreeInitialItems(){
    final List<Widget> items = _createNAnyButtons(0, 3);
    return items;
  }

  //Se llama solo cuando 2 < currentPage < state.nPages - 1
  List<Widget> _createNItems(){
    List<Widget> items;
    if(_currentIndex >= _nPages - 3){
      items = _createItemsInThreeLastPosition();
    }else{  
      items = _createNIntermediatesItems();
    }  
    return items;                                   
  }

  List<Widget> _createItemsInThreeLastPosition(){
    final List<Widget> items = [];
    items.add(_createIndexNumberButton(0));
    items.add(_createSingleText('...', false));
    List<Widget> threeNumberItems = _createNAnyButtons(_nPages - 3, 3);
    items.addAll(threeNumberItems);
    return items;
  }

  List<Widget> _createNIntermediatesItems(){
    final List<Widget> items = [];
    List<Widget> threeNumberItems = _createNAnyButtons(_currentIndex, 3);
    items.addAll(threeNumberItems);
    items.add(_createSingleText('...', false));
    items.add(_createIndexNumberButton(_nPages - 1));
    return items;
  }

  //El initialButton no necesariamente está posicionado en la actual posición del index.
  List<Widget> _createNAnyButtons(int initialButton, int nButtons){
    final List<Widget> buttons = [];
    for(int i = initialButton; i < initialButton + nButtons; i++){
      buttons.add(_createIndexNumberButton(i));
    }
    return buttons;
  }

  Widget _createIndexNumberButton(int buttonIndex){
    final Function onTap = _defineOnNumberButtonTap(buttonIndex);
    
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.zero,
        decoration: _createButtonDecoration(),
        //buttonIndex + 1, porque se debe mostrar de 1(y no de 0) en adelante.
        child: _createIndexNumberText(buttonIndex),
      ),
      onTap: onTap,
    );
  }

  Widget _createIndexNumberText(int buttonIndex){
    final Map<String, dynamic> buttonConfig = _getNumberButtonTextConfigByCurrentIndex(buttonIndex);
    return _createSingleText( (buttonIndex + 1).toString(), _definirSiNumberButtonIsActive(buttonIndex), buttonConfig['color'], buttonConfig['text_size']);
  }

  Map<String, dynamic> _getNumberButtonTextConfigByCurrentIndex(int buttonIndex){
    Color color;
    double textSize;
    if(state.currentIndexPage == buttonIndex){
      color = Theme.of(_context).primaryColor;
      textSize = _sizeUtils.subtitleSize * 0.85;
    }else{
      color = Theme.of(_context).primaryColor.withOpacity(0.75);
      textSize = _sizeUtils.subtitleSize * 0.8;
    }
    return {
      'color': color,
      'text_size':textSize
    };
  }

  Function _defineOnNumberButtonTap(int buttonIndex){
    final bool isActive = _definirSiNumberButtonIsActive(buttonIndex);
    if(isActive){
      return (){
        _changeIndex(buttonIndex);
      };
    }else{
      return null;
    }    
  }

  bool _definirSiNumberButtonIsActive(int buttonIndex){
    if(buttonIndex > _currentIndex && !_sePuedeAvanzar)
      return false;
    else
      return true;
  }

  Widget _createIndexTextButton(String buttonName){
    final Map<String, dynamic> onTapConfiguration = _definirTextButtonOnTapConfiguration(buttonName);
    Function onTap = _definirOnTextButtonTapFunction(onTapConfiguration['esta_activo'], onTapConfiguration['btn_index_navigation']);
    return FlatButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: _createButtonDecoration(),
        child: _createSingleText(buttonName.toString(), onTapConfiguration['esta_activo']),
      ),
      onPressed: onTap,
    );
  }

  Function _definirOnTextButtonTapFunction(bool estaActivo, int btnIndexNavigation){
    if(estaActivo){
      return (){
        _changeIndex(btnIndexNavigation);
      };
    }else{
      return null;
    }
  }

  Map<String, dynamic> _definirTextButtonOnTapConfiguration(String tipoMovimiento){
    final int currentIndex = _indexBloc.state.currentIndexPage;
    int bttnIndexNavigation;
    bool estaActivo;
    if(tipoMovimiento == 'Siguiente'){
      bttnIndexNavigation = currentIndex + 1;
      estaActivo = _sePuedeAvanzar;
    }else{
      bttnIndexNavigation = currentIndex - 1;
      estaActivo = _sePuedeRetroceder;
    }
    return {
      'btn_index_navigation':bttnIndexNavigation,
      'esta_activo':estaActivo
    };
  }

  void _changeIndex(int bttnIndexNavigation){
    final ChangeIndexPage changeIndexEvent = ChangeIndexPage(newIndexPage: bttnIndexNavigation);
    _indexBloc.add(changeIndexEvent);
    CommentedImagesIndexManagerSingleton.commImgIndexManager.definirActivacionAvanzarSegunCommentedImages();
  }

  BoxDecoration _createButtonDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045)
    );
  }

  Widget _createSingleText(String text, bool isActive, [Color color, double textSize]){
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize??_sizeUtils.subtitleSize * 0.8,
        color: color?? ((isActive)? Theme.of(_context).primaryColor.withOpacity(0.85) : Theme.of(_context).primaryColor.withOpacity(0.35))
      ),
    );
  }
}