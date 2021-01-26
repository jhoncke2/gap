import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/widgets/index/index_bloc.dart';
import 'package:gap/utils/size_utils.dart';

class IndexPagination extends StatelessWidget {
  IndexPagination();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, IndexState state) {
        if(state.nPages > 0){
          print(state);
          return _LoadedFormInputsIndex(state: state);
        }else{
          return Container();
        }
      },
    );
  }
}


// ignore: must_be_immutable
class _LoadedFormInputsIndex extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final IndexState state;
  final int _nPages;
  final int _currentIndex;

  BuildContext _context;
  MainAxisAlignment _centralItemsMainAxisAlignment;
  List<Widget> _centralItems;

  _LoadedFormInputsIndex({
    @required this.state
  }):
    _nPages = state.nPages,
    _currentIndex = state.currentIndex
    ;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.0375,
      width: _sizeUtils.xasisSobreYasis * 0.4875,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _createButtonsItems(),
      ),
    );
  }

  List<Widget> _createButtonsItems(){
    final List<Widget> items = [];
    items.add( _createIndexTextButton('Anterior') );
    //TODO: Implementación de items centrales
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
    if(_currentIndex > _nPages - 3){
      items = _createItemsInThreeLastPosition();
    }else{  
      items = _createNIntermediatesItems();
    }  
    return items;                                   
  }

  List<Widget> _createItemsInThreeLastPosition(){
    final List<Widget> items = [];
    items.add(_createIndexNumberButton(0));
    items.add(_createSingleText('...'));
    _createNAnyButtons(_nPages - 3, 3);
    return items;
  }

  List<Widget> _createNIntermediatesItems(){
    final List<Widget> items = [];
    _createNAnyButtons(_currentIndex, 3);
    items.add(_createSingleText('...'));
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
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.zero,
        decoration: _createButtonDecoration(),
        //buttonIndex + 1, porque se debe mostrar de 1(y no de 0) en adelante.
        child: _createSingleText( (buttonIndex + 1).toString()),
      ),
      onTap: (){

      },
    );
  }

  Widget _createIndexTextButton(String buttonName){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.zero,
        decoration: _createButtonDecoration(),
        child: _createSingleText(buttonName.toString()),
      ),
      onTap: (){

      },
    );
  }

  BoxDecoration _createButtonDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045)
    );
  }

  Widget _createSingleText(String text){
    return Text(
      text,
      style: TextStyle(
        fontSize: _sizeUtils.subtitleSize,
        color: Theme.of(_context).primaryColor.withOpacity(0.85)
      ),
    );
  }
}