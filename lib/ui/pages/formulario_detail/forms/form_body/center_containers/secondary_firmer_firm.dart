import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/utils/static_data/types_of_identif_document.dart' as typesOfIdentfDocuments;
import 'firm_fields/firm_draw_field/firm_field.dart';
import 'firm_fields/firm_select/firm_select_without_name.dart';
import 'firm_fields/text_field/text_field_without_name.dart';

// ignore: must_be_immutable
class SecondaryFirmerFirm extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormBloc _chosenFormBloc;
  ChosenFormState _chosenFormState;
  PersonalInformation _firmer;
  final TextEditingController _nameController;
  final TextEditingController _identifDocNumberController;
  SecondaryFirmerFirm():
    _nameController = TextEditingController(),
    _identifDocNumberController = TextEditingController()
    ;

  @override
  Widget build(BuildContext context) {
    _initInitialConfig(context);
    return Container(
      child: Column(
        children: [
          FirmField(firmer: _firmer),
          _createBottomFields()
        ],
      ),
    );
  }

  void _initInitialConfig(BuildContext context){
    _initContextDependentElements(context);
    _initFirmer();
    _initTextFieldController();
  }

  void _initContextDependentElements(BuildContext context){
    _context = context;
    _chosenFormBloc = BlocProvider.of<ChosenFormBloc>(_context);
    _chosenFormState = _chosenFormBloc.state;
  }

  void _initFirmer(){
    final int firmsLength = _chosenFormState.firmers.length;
    _firmer = _chosenFormState.firmers[firmsLength - 1];
  }

  void _initTextFieldController(){
    _nameController.text = _firmer.name??'';
    _nameController.selection = TextSelection.fromPosition(TextPosition(offset: _nameController.text.length));
    _identifDocNumberController.text = '';
    int identifDocumentNumber = _firmer.identifDocumentNumber;
    if(identifDocumentNumber != null){
      _identifDocNumberController.text = identifDocumentNumber.toString();
    }
    _identifDocNumberController.selection = TextSelection.fromPosition(TextPosition(offset: _identifDocNumberController.text.length));
  }

  Widget _createBottomFields(){
    return Container(
      child: Column(
        children: [
          _createNameField(),
          _createIdDocumentFields()
        ],
      ),
    );
  }

  Widget _createNameField(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createNameText(),
          TextFieldWithoutName(onFieldChanged: _onNameChange, width: _sizeUtils.xasisSobreYasis * 0.4, controller: _nameController, key: Key('firmer_${_chosenFormState.firmers.length}_name'))
        ],
      ),
    );
  }

  void _onNameChange(String newValue){
    _firmer.name = newValue;
    _updateFirmerPersInformation();
  }

  Widget _createIdDocumentFields(){
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FirmSelectWitouthName(items: typesOfIdentfDocuments.typesOfIdentfDocument, onFieldChanged: _onIdDocumentTypeChanged, width: _sizeUtils.xasisSobreYasis * 0.14, initialValue: _firmer.identifDocumentType, key: Key('firmer_${_chosenFormState.firmers.length}_doctype')),
          TextFieldWithoutName(onFieldChanged: _onIdDocumentNumberChanged, width: _sizeUtils.xasisSobreYasis * 0.4, controller: _identifDocNumberController, keyboardType: TextInputType.number, key: Key('firmer_${_chosenFormState.firmers.length}_docnumber'))
        ],
      ),
    );
  }

  void _onIdDocumentTypeChanged(int typeIndex){
    _firmer.identifDocumentType = typesOfIdentfDocuments.typesOfIdentfDocument[typeIndex];
    _updateFirmerPersInformation();
  }

  void _onIdDocumentNumberChanged(String newValue){
    //newValue = newValue.replaceAll(RegExp(r'.'), '');
    //newValue = newValue.replaceAll(RegExp(r','), '');
    //newValue = newValue.replaceAll(RegExp(r'-'), '');
    int number = _getNumberOfValue(newValue);
    _firmer.identifDocumentNumber = number;
    //_firmer.identifDocumentNumber = int.parse(newValue);
    _updateFirmerPersInformation();
  }

  int _getNumberOfValue(String newValue){
    String resultantValue = '';
    for(int i = 0; i < newValue.length; i++){
      if(!_charIsUnacceptableSymbol(newValue[i]))
        resultantValue += newValue[i];
    }
    return int.parse(resultantValue);
  }

  bool _charIsUnacceptableSymbol(String char){
    return ['.', ',', '-'].contains(char);
  }

  void _updateFirmerPersInformation(){
    final UpdateFirmerPersonalInformation ufpiEvent = UpdateFirmerPersonalInformation(firmer: _firmer);
    _chosenFormBloc.add(ufpiEvent);
  }

  Widget _createNameText(){
    return Text(
      'Nombre',
      style: TextStyle(
        fontSize: _sizeUtils.subtitleSize,
        color: Theme.of(_context).primaryColor
      )
    );
  }
}