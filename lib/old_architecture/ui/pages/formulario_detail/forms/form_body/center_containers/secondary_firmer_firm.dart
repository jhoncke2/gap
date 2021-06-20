import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/ui/utils/static_data/firmers_select_data.dart' as typesOfIdentfDocuments;
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'firm_fields/firm_select/firm_select_without_name.dart';
import 'firm_fields/text_field/text_field_without_name.dart';
import 'firm_fields/firm_draw_field/firm_field.dart';

// ignore: must_be_immutable
class SecondaryFirmerFirm extends StatefulWidget{
  final TextEditingController _nameController;
  final TextEditingController _identifDocNumberController;
  final TextEditingController _cargoController;
  SecondaryFirmerFirm():
    _nameController = TextEditingController(),
    _identifDocNumberController = TextEditingController(),
    _cargoController = TextEditingController()
    ;

  @override
  _SecondaryFirmerFirmState createState() => _SecondaryFirmerFirmState();
}

class _SecondaryFirmerFirmState extends State<SecondaryFirmerFirm> {
  final SizeUtils _sizeUtils = SizeUtils();

  BuildContext _context;
  ChosenFormBloc _chosenFormBloc;
  ChosenFormState _chosenFormState;
  PersonalInformationOld _firmer;
  int _dataTypeIndex;

  @override
  void initState() { 
    super.initState();
    _dataTypeIndex = 0;
  }

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
    widget._nameController.text = _firmer.name??'';
    widget._nameController.selection = TextSelection.fromPosition(TextPosition(offset: widget._nameController.text.length));
    widget._identifDocNumberController.text = '';
    widget._cargoController.text = _firmer.cargo??'';
    widget._cargoController.selection = TextSelection.fromPosition(TextPosition(offset: widget._cargoController.text.length));
    int identifDocumentNumber = _firmer.identifDocumentNumber;
    if(identifDocumentNumber != null){
      widget._identifDocNumberController.text = identifDocumentNumber.toString();
    }
    widget._identifDocNumberController.selection = TextSelection.fromPosition(TextPosition(offset: widget._identifDocNumberController.text.length));
  }

  Widget _createBottomFields(){
    return Container(
      child: Column(
        children: [
          _createNameField(),
          _createFirmerDataType(),
          _createIdDocumentFields(),
          _createCargoFields()
        ],
      ),
    );
  }

  Widget _createNameField(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createText('Nombre'),
          TextFieldWithoutName(
            onFieldChanged: _onNameChange, 
            width: _sizeUtils.xasisSobreYasis * 0.4, 
            controller: widget._nameController, 
            key: Key('firmer_${_chosenFormState.firmers.length}_name'
          ))
        ],
      ),
    );
  }

  Widget _createText(String text){
    return Text(
      text,
      style: TextStyle(
        fontSize: _sizeUtils.subtitleSize,
        color: Theme.of(_context).primaryColor
      )
    );
  }

  void _onNameChange(String newValue){
    _firmer.name = newValue;
    _updateFirmerPersInformation();
  }

  Widget _createFirmerDataType(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createText('datos'),
        FirmSelectWitouthName(
          items: typesOfIdentfDocuments.typesOfFirmerData,
          onFieldChanged: _onDataTypeChange,
          width: _sizeUtils.xasisSobreYasis * 0.4,
          initialValue: typesOfIdentfDocuments.typesOfFirmerData[_dataTypeIndex],
          key: Key('firmer_${_chosenFormState.firmers.length}_datatype')
        )
      ],
    );
  }

  void _onDataTypeChange(int newValueIndex){
    setState(() {
      if(newValueIndex == 0){
        _firmer.cargo = null;
        _updateFirmerPersInformation();
      }else if(newValueIndex == 1){
        _firmer.identifDocumentType = null;
        _firmer.identifDocumentNumber = null;
        _updateFirmerPersInformation();
      }
      _dataTypeIndex = newValueIndex;
    });
  }

  Widget _createIdDocumentFields(){
    if([0,2].contains(_dataTypeIndex))
      return Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FirmSelectWitouthName(
              items: typesOfIdentfDocuments.typesOfIdentfDocument, 
              onFieldChanged: _onIdDocumentTypeChanged, 
              width: _sizeUtils.xasisSobreYasis * 0.14, 
              initialValue: _firmer.identifDocumentType, 
              key: Key('firmer_${_chosenFormState.firmers.length}_doctype')
            ),
            TextFieldWithoutName(
              onFieldChanged: _onIdDocumentNumberChanged, 
              width: _sizeUtils.xasisSobreYasis * 0.4, 
              controller: widget._identifDocNumberController, 
              keyboardType: TextInputType.number, 
              key: Key('firmer_${_chosenFormState.firmers.length}_docnumber')
            )
          ],
        ),
      );
    else
      return Container();
  }

  void _onIdDocumentTypeChanged(int docTypeIndex){
    if(docTypeIndex == 0){
       _firmer.identifDocumentType = 'CC';
    }
    //_firmer.identifDocumentType = typesOfIdentfDocuments.typesOfIdentfDocument[typeIndex];
    _updateFirmerPersInformation();
  }

  void _onIdDocumentNumberChanged(String newValue){
    int number = _getNumberOfValue(newValue);
    _firmer.identifDocumentNumber = number;
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

  Widget _createCargoFields(){
    if([1,2].contains(_dataTypeIndex))
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createText('Cargo'),
          TextFieldWithoutName(
            //initialValue: _firmer.cargo,
            controller: widget._cargoController,
            onFieldChanged: _onCargoChanged, 
            width: _sizeUtils.xasisSobreYasis * 0.4, 
            key: Key('firmer_${_chosenFormState.firmers.length}_cargo'
          ))
        ],
      );
    else
      return Container();
  }

  void _onCargoChanged(String newValue){
    _firmer.cargo = newValue;
    _updateFirmerPersInformation();
  }

  bool _charIsUnacceptableSymbol(String char){
    return ['.', ',', '-'].contains(char);
  }

  void _updateFirmerPersInformation(){
    final UpdateFirmerPersonalInformation ufpiEvent = UpdateFirmerPersonalInformation(firmer: _firmer);
    _chosenFormBloc.add(ufpiEvent);
  }
}