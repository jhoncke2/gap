import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/firm_field.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_select/form_select_without_name.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/form_single_text/form_single_text_without_name.dart';
import 'package:gap/ui/utils/static_data/types_of_identif_document.dart' as typesOfIdDocuments;
// ignore: must_be_immutable
class OtherFirmerFirm extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormState _chosenFormState;
  PersonalInformation _firmer;
  OtherFirmerFirm();

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
        children: [
          _createNameText(),
          FormSingleTextWithoutName(onFieldChanged: _onNameChange)
        ],
      ),
    );
  }

  void _onNameChange(String newValue){
    
  }

  Widget _createIdDocumentFields(){
    return Container(
      child: Row(
        children: [
          FormSelectWitouthName(items: typesOfIdDocuments.typesOfIdentfDocument, onFieldChanged: _onIdDocumentTypeChanged, width: _sizeUtils.xasisSobreYasis * 0.075),
          FormSingleTextWithoutName(onFieldChanged: _onIdDocumentNumberChanged)
        ],
      ),
    );
  }

  void _onIdDocumentTypeChanged(int typeIndex){

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

  void _initInitialConfig(BuildContext context){
    _context = context;
    _chosenFormState = BlocProvider.of<ChosenFormBloc>(_context).state;
    _firmer = _chosenFormState.firmers[0];
  }
}