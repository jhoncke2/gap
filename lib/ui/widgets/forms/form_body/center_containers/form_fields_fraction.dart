import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_field_widget_factory.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
// ignore: must_be_immutable
class FormInputsFraction extends StatefulWidget {

  final ScrollController formFieldsScrollController = ScrollController();
  bool alreadyOnceBuilded = false;
  double lastScrollOffset = 0;
  // ignore: close_sinks
  final StreamController<int> onTextFieldChangeController = StreamController.broadcast();
  Stream<int> onTextFieldTapStream;
  int currentTappedTextFormField;

  FormInputsFraction({Key key}) : super(key: key){
    onTextFieldTapStream = onTextFieldChangeController.stream;
  }

  @override
  _FormInputsFractionState createState() => _FormInputsFractionState();
}

class _FormInputsFractionState extends State<FormInputsFraction> {
  final SizeUtils _sizeUtils = SizeUtils();
  IndexState _indexState;
  bool _isReBuilding;
  double _listViewBotPadding;

  @override
  void initState() {
    _initOnTextFieldTapStream();
    _isReBuilding = false;
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    _initBuildingConfig(context);
    _unlockIndexIfFormFieldsAreCompleted();
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (_, IndexState state){
        _indexState = state;
        _doPostFrameBack();
        if(state.nPages > 0)
          return _createFormFieldsWithIndex();
        else
          return _createFormFieldsWithoutIndex();
      }
    );
  }

  void _initBuildingConfig(BuildContext context){
    _isReBuilding = true;
    if(KeyboardVisibilityNotification().isKeyboardVisible){
      _listViewBotPadding = 200;
    }
    else{
      _listViewBotPadding = 50;
    }
  }

  void _unlockIndexIfFormFieldsAreCompleted(){
    ChosenFormManagerSingleton.chosenFormManager.updateIndexByFormFieldsChange();
  }

  void _doPostFrameBack(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(!_isReBuilding)
        _animateScrollToInitialOffset();
      _isReBuilding = false;
    });
  }

void _initOnTextFieldTapStream(){
    widget.onTextFieldTapStream.listen((int tappedIndex) {
      _moveScrollByTappedFormIndex(tappedIndex);
    });
  }

  void _moveScrollByTappedFormIndex(int index){
    final newScrollOffset = defineOffsetPositionByIndex(index);
    _animateScrollToPosition(newScrollOffset);
  }

  double defineOffsetPositionByIndex(int index){
    switch(index){
      case 0:
        return 0.0;
      case 1:
        return 100.0;
      case 2:
        return 200.0;
      case 3:
        return 400.0;
      default:
        return 450.0;
    }
  }

  void _animateScrollToInitialOffset(){
    widget.lastScrollOffset = 0.0;
    //widget.formFieldsScrollController.jumpTo(widget.lastScrollOffset);
    widget.formFieldsScrollController.animateTo(widget.lastScrollOffset, duration: Duration(milliseconds: 2), curve: Curves.bounceIn);
  }

  Future _animateScrollToPosition(double offset)async{
    await widget.formFieldsScrollController.animateTo(offset, duration: Duration(milliseconds: 15), curve: Curves.bounceIn);
    print(widget.formFieldsScrollController.offset);
  }

  Widget _createFormFieldsWithIndex(){
    List<CustomFormField> formFIeldsByPage = _getFormFIeldsByCurrentPage();
    return SingleChildScrollView(
      child: Container(
        child: ListView.separated(
          controller: widget.formFieldsScrollController,
          itemCount: formFIeldsByPage.length,
          separatorBuilder: (_, __)=>SizedBox(height: _sizeUtils.xasisSobreYasis * 0.1),
          itemBuilder: (_, int i)=>FormFieldWidgetFactory.createFormFieldWidget(formFIeldsByPage[i], i, widget.onTextFieldChangeController),
          padding: EdgeInsets.only(top: 10, bottom: _listViewBotPadding),
        ),
        height: _sizeUtils.xasisSobreYasis * 0.65,
        width: double.infinity,
      )
    );
  }

  Widget _createFormFieldsWithoutIndex(){
    return Container();
  }

  List<CustomFormField> _getFormFIeldsByCurrentPage(){
    final int currentPage = _indexState.currentIndexPage;
    final ChosenFormBloc cfBloc = BlocProvider.of<ChosenFormBloc>(context);
    final List<CustomFormField> formFieldsByCurrentPage = cfBloc.state.getFormFieldsByIndex(currentPage);
    return formFieldsByCurrentPage;
  }

  @override
  void dispose() {
    widget.onTextFieldChangeController.close();
    super.dispose();
  }
}