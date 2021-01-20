import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/formularios/formularios_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/models/formulario.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header/header.dart';
import 'package:gap/widgets/page_title.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_nav_items.dart';

// ignore: must_be_immutable
class FormularioDetailPage extends StatelessWidget {
  static final String route = 'formulario_detail';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  Formulario _formulario;
  FormularioDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(body: SafeArea(
      child: BlocBuilder<FormulariosBloc, FormulariosState>(
        builder: (context, state) {
          if(state.chosenForm != null){          
            return _createFormComponents(state);
          }else{
            return UnloadedNavItems();
          }
        },
      ),
    ));
  }

  Widget _createFormComponents(FormulariosState state){
    _formulario = state.chosenForm;
    return Column(
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        Header(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createFormularioComponents(state)
      ],
    );
  }

  Widget _createFormularioComponents(FormulariosState state){
    final String chosenVisitName = _getChosenVisitName();
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.75,
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.05),
      child: Column(
        children: [
          PageTitle(title: chosenVisitName, underlined: false),
          SizedBox(height: _sizeUtils.veryLittleSizedBoxHeigh),
          _createInitFullDate(state)
        ],
      )
    );
  }

  String _getChosenVisitName(){
    final VisitsBloc vBloc = BlocProvider.of<VisitsBloc>(_context);
    final String chosenVisitName = vBloc.state.chosenVisit.name;
    return chosenVisitName;
  }

  Widget _createInitFullDate(FormulariosState state){
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