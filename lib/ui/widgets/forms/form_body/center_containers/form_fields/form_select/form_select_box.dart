import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class FormSelectBox extends StatelessWidget{
  final SizeUtils _sizeUtils = SizeUtils();
  final List<String> items;
  final Function onSelected;
  BuildContext _context;
  List<PopupMenuEntry<int>> _popupItems;
  String _selectedValue;
  
  FormSelectBox({
    @required this.items,
    @required this.onSelected,
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
    return Container(
      width: double.infinity,
      height: _sizeUtils.xasisSobreYasis * 0.075,
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createPopupChildText(),
          _createPopupChildIcon()
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.065),
        border: _createBoxBorder()
      ),
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