import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/models/entities/formulario.dart';
import 'package:gap/widgets/page_title.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class LoadedFormHead extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  final Formulario _formulario;
  BuildContext _context;
  LoadedFormHead({
    @required this.formsState
  }):
    this._formulario = formsState.chosenForm
    ;

  @override
  Widget build(BuildContext context) {
    _context = context;
    final String chosenVisitName = _getChosenVisitName();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: chosenVisitName, underlined: false),
          SizedBox(height: _sizeUtils.veryLittleSizedBoxHeigh),
          _createInitFullDate(),
        ],
      ),
    );
  }

  String _getChosenVisitName(){
    final VisitsBloc vBloc = BlocProvider.of<VisitsBloc>(_context);
    final String chosenVisitName = vBloc.state.chosenVisit.name;
    return chosenVisitName;
  }

  Widget _createInitFullDate(){
    return Row(
      children: [
        _createFullDateChild('Fecha: ${_formulario.initialDate}'),
        _createVerticalDivider(),
        _createFullDateChild('Hora inicio: ${_formulario.initialTime}')
      ],
    );
  }

  Widget _createFullDateChild(String fullDateChild){
    return Expanded(
      child: Text(
        fullDateChild,
        style: TextStyle(
          color: Theme.of(_context).primaryColor,
          fontSize: _sizeUtils.normalTextSize
        ),
      ),
    );
  }

  Widget  _createVerticalDivider(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.02),
      color: Theme.of(_context).primaryColor,
      width: 1,
      height: _sizeUtils.xasisSobreYasis * 0.03,
    );
  }
}