import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/keyboard_listener/keyboard_listener_bloc.dart';
import 'package:gap/old_architecture/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'form_fields/form_field_widget_factory.dart';

// ignore: must_be_immutable
class FormInputsFraction extends StatefulWidget {

  final ScrollController formFieldsScrollController = ScrollController();
  double lastScrollOffset = 0;
  // ignore: close_sinks
  final StreamController<int> onTextFieldChangeController = StreamController.broadcast();
  Stream<int> onTextFieldTapStream;
  final ScrollController elementsScrollController = ScrollController();
  double screenHeightPercent;
  final bool formFieldsAreEnabled;
  int lastIndexPage;
  bool widgetAlreadyBuilder = false;

  FormInputsFraction({Key key, @required this.screenHeightPercent, @required this.formFieldsAreEnabled}) : super(key: key){
    onTextFieldTapStream = onTextFieldChangeController.stream;
  }

  @override
  _FormInputsFractionState createState() => _FormInputsFractionState();
}

class _FormInputsFractionState extends State<FormInputsFraction> {
  final SizeUtils _sizeUtils = SizeUtils();
  int latIndexPage;
  IndexState _indexState;
  bool _isReBuilding;

  @override
  void initState() {
    super.initState();
    _isReBuilding = false;
  }

  @override
  Widget build(BuildContext context) {
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

  void _unlockIndexIfFormFieldsAreCompleted(){
    ChosenFormManagerSingleton.chosenFormManager.updateIndexByFormFieldsChange();
  }

  void _doPostFrameBack(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      //if(!_isReBuilding)
       // _animateScrollToInitialOffset();
      //_isReBuilding = false;

      //final keyboardState = BlocProvider.of<KeyboardListenerBloc>(context).state;
      int currentIndexPage = _indexState.currentIndexPage;
      if(latIndexPage != currentIndexPage){
        latIndexPage = currentIndexPage;
        widget.elementsScrollController.jumpTo(0.0);
      }  
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
    //widget.formFieldsScrollController.animateTo(widget.lastScrollOffset, duration: Duration(milliseconds: 2), curve: Curves.bounceIn);
  }

  Future _animateScrollToPosition(double offset)async{
    //await widget.formFieldsScrollController.animateTo(offset, duration: Duration(milliseconds: 15), curve: Curves.bounceIn);
    print(widget.formFieldsScrollController.offset);
  }

  Widget _createFormFieldsWithIndex(){
    
    List<CustomFormFieldOld> formFIeldsByPage = _getFormFIeldsByCurrentPage();
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Scrollbar(
        controller: widget.elementsScrollController,
        isAlwaysShown: true,
        child: ListView.separated(
          controller: widget.elementsScrollController,
          itemCount: formFIeldsByPage.length,
          separatorBuilder: (_, __)=>SizedBox(height: _sizeUtils.xasisSobreYasis * 0.05),
          itemBuilder: (_, int i)=>FormFieldWidgetFactory.createFormFieldWidget(formFIeldsByPage[i], i, widget.onTextFieldChangeController, widget.formFieldsAreEnabled),
          padding: EdgeInsets.only(top: 0, bottom: 50),
        ),
      ),
      height: screenHeight * widget.screenHeightPercent,
      width: double.infinity,
    );
  }

  Widget _createFormFieldsWithoutIndex(){
    return Container();
  }

  List<CustomFormFieldOld> _getFormFIeldsByCurrentPage(){
    final int currentPage = _indexState.currentIndexPage;
    final ChosenFormBloc cfBloc = BlocProvider.of<ChosenFormBloc>(context);
    final List<CustomFormFieldOld> formFieldsByCurrentPage = cfBloc.state.getFormFieldsByIndex(currentPage);
    return formFieldsByCurrentPage;
  }

  @override
  void dispose() {
    widget.onTextFieldChangeController.close();
    super.dispose();
  }
}