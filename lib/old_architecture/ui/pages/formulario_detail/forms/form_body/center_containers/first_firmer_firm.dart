import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

import 'firm_fields/firm_draw_field/firm_field.dart';
// ignore: must_be_immutable
class FirstFirmerFirm extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  ChosenFormState _chosenFormState;
  PersonalInformationOld _firmer;
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