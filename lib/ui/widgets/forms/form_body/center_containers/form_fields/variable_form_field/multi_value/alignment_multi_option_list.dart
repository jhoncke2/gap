import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/ui/utils/size_utils.dart';

class AlignmentedMultiOptionList extends StatefulWidget {
  final bool withVerticalAlignment;
  final List<MultiFormFieldValue> values;
  final Function(MultiFormFieldValue, Function(Function)) onItemCreated;

  AlignmentedMultiOptionList({
    Key key,
    @required this.withVerticalAlignment,
    @required this.values,
    @required this.onItemCreated
  }): super(key: key);

  @override
  _AlignmentedMultiOptionListState createState() => _AlignmentedMultiOptionListState();
}

class _AlignmentedMultiOptionListState extends State<AlignmentedMultiOptionList> {
  
  final SizeUtils _sizeUtils = SizeUtils();
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
    if(widget.withVerticalAlignment)
      _defineVerticalItems();
    else
      _defineHorizontalItems();
  }

  void _defineVerticalItems(){
    _items = Column(
      children: _createCheckBoxItems(),
    );
  }

  void _defineHorizontalItems(){
    final List<Widget> checkBoxItems = _createCheckBoxItems();
    _items = _HorizontalMultiOptionItems(items: checkBoxItems);
  }

  List<Widget> _createCheckBoxItems(){
    final List<Widget> items = [];
    widget.values.forEach(
      (value){
        items.add(widget.onItemCreated(value, _resetState));
      }
    );
    return items;
  }

  void _resetState(Function actionInSetState){
    setState(actionInSetState);
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