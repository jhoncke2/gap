import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/utils/size_utils.dart';

// ignore: must_be_immutable
class VisitsDateFilter extends StatelessWidget {
  final List<String> _menuItemsNames = ['Hoy', 'Mañana', 'Elige un día'];
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  List<PopupMenuEntry<int>> _menuItems;
  VisitsState _currentVisitsState;
  VisitsDateFilter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return BlocBuilder<VisitsBloc, VisitsState>(
      builder: (context, VisitsState state) {
        _currentVisitsState = state;
        _instanciarPopupItems();
        return PopupMenuButton<int>(
          initialValue: state.indexOfChosenFilterItem,
          onSelected: (int index) => _onPopUpSelected(index),
          elevation: 0.75,
          shape: _createMenuShape(),
          offset: Offset(
            _sizeUtils.xasisSobreYasis * 0.01,
            _sizeUtils.xasisSobreYasis * 0.07,
          ),
          padding: EdgeInsets.all(0.0),
          child: _crearPopUpChild(),
          itemBuilder: (BuildContext context) {
            return _menuItems;
          },
        );
      },
    );
  }

  ShapeBorder _createMenuShape() {
    return RoundedRectangleBorder(
      side: BorderSide(
        color: Theme.of(_context).primaryColor.withOpacity(0.55),
        width: 2.5
      ),
      borderRadius:BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.028)
    );
  }

  void _initInitialConfiguration(BuildContext appContext) {
    _context = appContext;
  }

  void _instanciarPopupItems() {
    _menuItems = [];
    for (int i = 0; i < _menuItemsNames.length; i++) {
      final String name = _menuItemsNames[i];
      _menuItems.add(
          PopupMenuItem<int>(value: i, child: _crearItemsDePopUpItem(i, name)));
    }
  }

  Widget _crearItemsDePopUpItem(int itemIndex, String name) {
    final List<Widget> rowChildren = [
      Text(
        name,
        style: TextStyle(
            color: Theme.of(_context).primaryColor,
            fontSize: _sizeUtils.normalTextSize),
      )
    ];
    if (itemIndex == 2) {
      rowChildren.addAll([
        SizedBox(width: _sizeUtils.xasisSobreYasis * 0.03),
        Icon(
          FontAwesomeIcons.calendarAlt,
          color: Theme.of(_context).primaryColor,
          size: _sizeUtils.largeIconSize * 0.8,
        )
      ]);
    }
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowChildren,
      ),
    );
  }

  Widget _crearPopUpChild() {
    String itemText;
    final DateTime selectedDate = _currentVisitsState.filterDate;
    if(selectedDate != null){
      itemText = '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
    }else{
      itemText = 'Filtrar';
    }
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.25,
      child: Row(
        children: <Widget>[
          Text(
            itemText,
            style: TextStyle(
              fontSize: _sizeUtils.subtitleSize,
              color: Theme.of(_context).primaryColor
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(_context).primaryColor.withOpacity(0.75),
            size: _sizeUtils.extraLargeIconSize,
          ),
        ],
      ),
    );
  }

  void _onPopUpSelected(int index) async {
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(_context);
    final DateTime selectedDate = await _hallarDateSegunItem(index);
    final ChangeDateFilterItem event = ChangeDateFilterItem(
      filterItemIndex: index, 
      filterDate: selectedDate
    );
    visitsBloc.add(event);
  }

  Future<DateTime> _hallarDateSegunItem(int index)async{
    switch(index){
      case 0:
        return DateTime.now();
      case 1:
        return DateTime.now().add(Duration(days: 1));
      case 2:
        return showDatePicker(
          context: _context,
          initialDate: DateTime.now(), 
          firstDate: DateTime.now().subtract(Duration(days: 21)), 
          lastDate: DateTime(2030, 12, 31)
        );
    }
    return null;
  }
}