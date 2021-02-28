import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/firm_fields/firm_select/firm_select_with_name.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/firm_fields/firm_text_field/text_field_with_name.dart';
import 'package:gap/ui/utils/static_data/types_of_identif_document.dart' as typesOfIdentfDocument;
// ignore: must_be_immutable
class FirstFirmerPersInfo extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  ChosenFormBloc _chosenFormBloc;
  ChosenFormState _chosenFormState;
  PersonalInformation _firmer;
  FirstFirmerPersInfo();

  @override
  Widget build(BuildContext context){
    _initBlocConfig(context);
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFieldWithName(fieldName: 'Nombre de quien atiende', onFieldChanged: _onNombreChanged),
          FirmSelectWithName(fieldName: 'Tipo de documento', items: typesOfIdentfDocument.typesOfIdentfDocument, initialValue: _firmer.identifDocumentType, onFieldChanged: _onTipoDocumentoChanged),
          TextFieldWithName(fieldName: 'Número de documento', onFieldChanged: _onNumDocumentoChanged)
        ],
      ),
    );
  }

  void _initBlocConfig(BuildContext context){
    _chosenFormBloc = BlocProvider.of<ChosenFormBloc>(context);
    _chosenFormState = _chosenFormBloc.state;
    _firmer = _chosenFormState.firmers[0];
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