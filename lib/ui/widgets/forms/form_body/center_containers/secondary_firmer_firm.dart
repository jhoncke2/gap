import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/firm_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_select/form_select_without_name.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_single_text/form_single_text_without_name.dart';
import 'package:gap/ui/utils/static_data/types_of_identif_document.dart' as typesOfIdentfDocuments;
// ignore: must_be_immutable
class SecondaryFirmerFirm extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormBloc _chosenFormBloc;
  ChosenFormState _chosenFormState;
  PersonalInformation _firmer;
  SecondaryFirmerFirm();

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
    _context = context;
    _chosenFormBloc = BlocProvider.of<ChosenFormBloc>(_context);
    _chosenFormState = _chosenFormBloc.state;
    final int firmsLength = _chosenFormState.firmers.length;
    _firmer = _chosenFormState.firmers[firmsLength - 1];
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
          FormSingleTextWithoutName(onFieldChanged: _onNameChange, width: _sizeUtils.xasisSobreYasis * 0.4)
        ],
      ),
    );
  }

  void _onNameChange(String newValue){
    
  }

  Widget _createIdDocumentFields(){
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FormSelectWitouthName(items: typesOfIdentfDocuments.typesOfIdentfDocument, onFieldChanged: _onIdDocumentTypeChanged, width: _sizeUtils.xasisSobreYasis * 0.14, initialValue: _firmer.identifDocumentType),
          FormSingleTextWithoutName(onFieldChanged: _onIdDocumentNumberChanged, width: _sizeUtils.xasisSobreYasis * 0.4)
        ],
      ),
    );
  }

  void _onIdDocumentTypeChanged(int typeIndex){
    _firmer.identifDocumentType = typesOfIdentfDocuments.typesOfIdentfDocument[typeIndex];
    final UpdateFirmerPersonalInformation ufpiEvent = UpdateFirmerPersonalInformation(firmer: _firmer);
    _chosenFormBloc.add(ufpiEvent);
  }

  void _onIdDocumentNumberChanged(String newValue){

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