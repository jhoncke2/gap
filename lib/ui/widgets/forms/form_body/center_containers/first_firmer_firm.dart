import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/firm_field.dart';
// ignore: must_be_immutable
class FirstFirmerFirm extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormState _chosenFormState;
  PersonalInformation _firmer;
  FirstFirmerFirm();

  @override
  Widget build(BuildContext context) {
    _initInitialConfig(context);
    return Container(
      child: Column(
        children: [
          FirmField(firmer: _firmer),
          _createFirmerInfoText(_firmer.name),
          _createFirmerInfoText('${_firmer.identifDocumentType} ${_firmer.identifDocumentNumber}')
        ],
      ),
    );
  }

  void _initInitialConfig(BuildContext context){
    _context = context;
    _chosenFormState = BlocProvider.of<ChosenFormBloc>(_context).state;
    _firmer = _chosenFormState.firmers[0];
  }

  Widget _createFirmerInfoText(String firmerInfo){
    return Text(
      firmerInfo,
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.normalTextSize
      ),
    );
  }
}