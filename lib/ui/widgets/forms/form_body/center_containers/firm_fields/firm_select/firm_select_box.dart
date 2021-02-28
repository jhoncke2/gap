import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/buttons/general_button.dart';
// ignore: must_be_immutable
class FirmSelectBox extends StatelessWidget{
  final SizeUtils _sizeUtils = SizeUtils();
  final List<String> items;
  final Function onSelected;
  final BtnBorderShape borderShape;
  BuildContext _context;
  BorderRadius _mainElementBorderRadius;
  List<PopupMenuEntry<int>> _popupItems;
  String _selectedValue;
  
  FirmSelectBox({
    @required this.items,
    @required this.onSelected,
    @required this.borderShape,
    String initialValue
  }):
    _selectedValue = initialValue
    ;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _instanciarPopupItems();
    return PopupMenuButton<int>(
      onSelected: (int index)=>this.onSelected(index),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.068)
      ),
      offset: Offset(
        -_sizeUtils.xasisSobreYasis * 0.025,
        _sizeUtils.xasisSobreYasis * 0.355,
      ),
      padding: EdgeInsets.all(0.0),
      child: _crearPopUpChild(),
      itemBuilder: (BuildContext context){
        return _popupItems;
      },
    );
  }

  void _instanciarPopupItems(){
    _popupItems = [];
    for(int i = 0; i < items.length; i++){
      String item = items[i];
      _popupItems.add(
        PopupMenuItem(
          value: i,
          child: Text(
            item,
            style: TextStyle(
              color: Theme.of(_context).primaryColor,
              fontSize: _sizeUtils.normalTextSize
            ),
          )
        )
      );
    }
  }

  Widget _crearPopUpChild(){
    _defineMainElementBorderRadius();
    return Container(
      width: double.infinity,
      height: _sizeUtils.xasisSobreYasis * 0.075,
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.0125),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createPopupChildText(),
          _createPopupChildIcon()
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: _mainElementBorderRadius,
        border: _createBoxBorder()
      ),
    );
  }

  void _defineMainElementBorderRadius(){
    if(borderShape == BtnBorderShape.Circular){
      _createCircularBorderRadius();
    }else{
      _createEllipticalBorderRadius();
    }
  }

  void _createCircularBorderRadius(){
    _mainElementBorderRadius =  BorderRadius.circular(
      _sizeUtils.xasisSobreYasis * 0.04
    );
  }

  void _createEllipticalBorderRadius(){
    _mainElementBorderRadius = BorderRadius.horizontal(
      left: Radius.elliptical(_sizeUtils.xasisSobreYasis * 0.0275, _sizeUtils.xasisSobreYasis * 0.05),
      right: Radius.elliptical(_sizeUtils.xasisSobreYasis * 0.0275, _sizeUtils.xasisSobreYasis * 0.05)
    );
  }

  Widget _createPopupChildText(){
    return Text(
      _selectedValue??'',
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.subtitleSize
      ),
    );
  }

  Widget _createPopupChildIcon(){
    return Icon(
      Icons.arrow_drop_down,
      color: Theme.of(_context).primaryColor.withOpacity(0.5),
      size: _sizeUtils.largeIconSize,
    );
  }

  BoxBorder _createBoxBorder(){
    return Border.all(
      color: Theme.of(_context).primaryColor.withOpacity(0.525),
      width: 3.5
    );
  }
}