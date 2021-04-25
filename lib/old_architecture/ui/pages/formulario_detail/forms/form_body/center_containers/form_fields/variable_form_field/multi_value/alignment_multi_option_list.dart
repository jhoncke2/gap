import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';

// ignore: must_be_immutable
class AlignmentedMultiOptionList extends StatelessWidget {

  final bool withVerticalAlignment;
  final List<MultiFormFieldValueOld> values;
  final Function(MultiFormFieldValueOld, Function(Function)) onItemCreated;

  AlignmentedMultiOptionList({
    Key key,
    @required this.withVerticalAlignment,
    @required this.values,
    @required this.onItemCreated
  }): super(key: key);

  Widget _items;

  @override
  Widget build(BuildContext context) {
    _defineListOfItems();
    return Container(
      width: double.infinity,
      child: _items,
    );
  }

  void _defineListOfItems(){
    if(withVerticalAlignment)
      _defineVerticalItems();
    else
      _defineHorizontalItems();
  }

  void _defineVerticalItems(){
    _items = Column(
      children: _createCheckBoxItems(),
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  void _defineHorizontalItems(){
    final List<Widget> checkBoxItems = _createCheckBoxItems();
    _items = _HorizontalMultiOptionItems(items: checkBoxItems);
  }

  List<Widget> _createCheckBoxItems(){
    final List<Widget> items = [];
    values.forEach(
      (value){
        items.add(onItemCreated(value, null));
      }
    );
    return items;
  }
}

// ignore: must_be_immutable
class _HorizontalMultiOptionItems extends StatelessWidget {
  final List<Widget> items;
  bool thereIsRestantElement;
  int itemsHalfLength;

  _HorizontalMultiOptionItems({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _createHorizontalListOfItems(),
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  List<Row> _createHorizontalListOfItems(){
    final List<Row> rowsOfItems = [];
    itemsHalfLength = (items.length/2).ceil();
    thereIsRestantElement = items.length % 2 != 0;
    for(int i = 0; i < itemsHalfLength; i++){
      rowsOfItems.add( _createCurrentRowOfCheckboxes(i) );
    }
    return rowsOfItems;
  }

  Row _createCurrentRowOfCheckboxes(int index){ 
    return Row(
      children: _defineRowWidgetsByIndex(index),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  List<Widget> _defineRowWidgetsByIndex(int index){
    if(thereIsRestantElement && index == itemsHalfLength-1){
      return [ items[index*2] ];
    }else{
      return [ items[index*2], SizedBox(width: 10), items[index*2 + 1] ];
    }
  }
}