import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/utils/static_data/firmers_select_data.dart' as typesOfIdentfDocument;
import 'firm_fields/firm_select/firm_select_with_name.dart';
import 'firm_fields/text_field/text_field_with_name.dart';
// ignore: must_be_immutable
class FirstFirmerPersInfo extends StatefulWidget {

  FirstFirmerPersInfo();

  @override
  _FirstFirmerPersInfoState createState() => _FirstFirmerPersInfoState();
}

class _FirstFirmerPersInfoState extends State<FirstFirmerPersInfo> {
  final SizeUtils _sizeUtils = SizeUtils();

  ChosenFormBloc _chosenFormBloc;
  ChosenFormState _chosenFormState;
  PersonalInformationOld _firmer;
  int _dataTypeIndex;

  @override
  void initState() {
    _dataTypeIndex = 0;
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    _initBlocConfig(context);
    return Container(
      height: ([0,2].contains(_dataTypeIndex))? 
        _sizeUtils.xasisSobreYasis * 0.69
        : _sizeUtils.xasisSobreYasis * 0.55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFieldWithName(
            fieldName: 'Nombre de quien atiende', 
            onFieldChanged: _onNombreChanged
          ),
          FirmSelectWithName(
            fieldName: 'Tipos de valores',
            items: typesOfIdentfDocument.typesOfFirmerData, 
            initialValue: typesOfIdentfDocument.typesOfFirmerData[_dataTypeIndex],
            onFieldChanged: _onTiposDeValoresChanged
          ),
          _createTipoDocumentoByFirmerValuesElegidos(),
          _createNumDocumentoByFirmerValuesElegidos(),
          _createCargoByFirmerValuesElegidos()
        ],
      ),
    );
  }

  void _initBlocConfig(BuildContext context){
    _chosenFormBloc = BlocProvider.of<ChosenFormBloc>(context);
    _chosenFormState = _chosenFormBloc.state;
    _firmer = _chosenFormState.firmers[0];
  }

  void _onTiposDeValoresChanged(int newValueIndex){
    setState(() {
      if(newValueIndex == 0)
        _firmer.cargo = null;
      else if(newValueIndex == 1){
        _firmer.identifDocumentType = null;
        _firmer.identifDocumentNumber = null;
      }
      _dataTypeIndex = newValueIndex;
    });
  }
  
  Widget _createTipoDocumentoByFirmerValuesElegidos(){
    return [0,2].contains( _dataTypeIndex )?
      FirmSelectWithName(
        fieldName: 'Tipo de documento', 
        items: typesOfIdentfDocument.typesOfIdentfDocument, 
        initialValue: _firmer.identifDocumentType, 
        onFieldChanged: _onTipoDocumentoChanged
      )
      : Container();
  }

  Widget _createNumDocumentoByFirmerValuesElegidos(){
    return [0,2].contains( _dataTypeIndex )?
      TextFieldWithName(
        fieldName: 'Número de documento', 
        onFieldChanged: _onNumDocumentoChanged
      ):
      Container();
  }

  Widget _createCargoByFirmerValuesElegidos(){
    return [1,2].contains( _dataTypeIndex )?
      TextFieldWithName(
        fieldName: 'Cargo', 
        onFieldChanged: _onCargoChanged
      ):
      Container();
  }

  void _onCargoChanged(String newValue){
    _firmer.cargo = newValue;
    _updateCurrentFirmer();
  }

  void _onNombreChanged(String newValue){
    _firmer.name = newValue;
    _updateCurrentFirmer();
  }

  void _onTipoDocumentoChanged(int newValue){
    _firmer.identifDocumentType = typesOfIdentfDocument.typesOfIdentfDocument[newValue];
    _updateCurrentFirmer();
  }

  void _onNumDocumentoChanged(String newValue){
    _firmer.identifDocumentNumber = int.parse(newValue);
    _updateCurrentFirmer();
  }

  void _updateCurrentFirmer(){
    final UpdateFirmerPersonalInformation afpiEvent = UpdateFirmerPersonalInformation(
      firmer: _firmer
    );
    _chosenFormBloc.add(afpiEvent);
  }
}