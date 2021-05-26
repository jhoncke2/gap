import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/notifier/visits_change_notifier.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:provider/provider.dart';
class DateFilter extends StatefulWidget {
  DateFilter({
    Key key
  }) : super(key: key);

  @override
  _DateFilterState createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  static final SizeUtils _sizeUtils = SizeUtils();
  final List<String> _menuItemsNames = ['Hoy', 'Mañana', 'Elige un día'];
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return PopupMenuButton<int>(
      initialValue: Provider.of<VisitsChangeNotifier>(context).selectedDateMenuIndex,
      onSelected: (int index) => _onPopUpSelected(index),
      elevation: 0.75,
      shape: _createMenuShape(),
      offset: Offset(
        _sizeUtils.xasisSobreYasis * 0.01,
        _sizeUtils.xasisSobreYasis * 0.07,
      ),
      padding: EdgeInsets.all(0.0),
      child: _crearPopUpChild(),
      itemBuilder: (_) => _instanciarPopupItems()
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

  List<PopupMenuEntry<int>> _instanciarPopupItems() {
    List<PopupMenuEntry<int>> menuItems = [];
    for (int i = 0; i < _menuItemsNames.length; i++) {
      menuItems.add(
          PopupMenuItem<int>(value: i, child: _crearItemsDePopUpItem(i, _menuItemsNames[i])));
    }
    return menuItems;
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
    if(itemIndex == 2){
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
    DateTime selectedDate = Provider.of<VisitsChangeNotifier>(context).selectedDate;
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
    DateTime selectedDate = await _hallarDateSegunItem(index);
    Provider.of<VisitsChangeNotifier>(context, listen: false).setCurrentSelectedDateFilter(index, selectedDate);
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