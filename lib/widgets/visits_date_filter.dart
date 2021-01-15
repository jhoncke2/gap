import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class VisitsDateFilter extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  List<Widget> _popupItems;
  VisitsDateFilter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return PopupMenuButton<int>(
      onSelected: (int index)=>_onPopUpSelected(index),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.028)
      ),
      offset: Offset(
        -_sizeUtils.xasisSobreYasis * 0.025,
        _sizeUtils.xasisSobreYasis * 0.275,
      ),
      padding: EdgeInsets.all(0.0),
      child: _crearPopUpChild(),
      itemBuilder: (BuildContext context){
        return _popupItems;
      },
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
  }

  void _instanciarPopupItems(){
    //TODO: Implementar con el bloc
    _popupItems = [];
    for(int i = 0; i < 10; i++){
      _popupItems.add(
        PopupMenuItem(
          value: i,
          child: _crearItemsDePopUpItem()
        )
      );
    }
  }

  Widget _crearItemsDePopUpItem(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Item')
      ],
    );
  }

  Widget _crearPopUpChild(){
    return Row(
      children: <Widget>[
        Text(
          'Filtrar',
          style: TextStyle(
            fontSize: _sizeUtils.normalTextSize,
            color: Theme.of(_context).primaryColor
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Theme.of(_context).primaryColor.withOpacity(0.75),
          size: _sizeUtils.extraLargeIconSize,
        ),
      ],
    );
  }


  void _onPopUpSelected(int index)async{

  }
}