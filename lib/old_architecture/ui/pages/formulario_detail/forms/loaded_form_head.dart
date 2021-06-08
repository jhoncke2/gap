import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/back_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/logout_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class LoadedFormHead extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  final FormularioOld _formulario;
  final bool hasBackButton;
  BuildContext _context;

  LoadedFormHead({@required this.formsState, this.hasBackButton = false})
      : this._formulario = formsState.chosenForm;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return BlocProvider<VisitsBloc>(
      create: (context) => sl(),
      child: Container(
        color: Colors.grey.withOpacity(0.2),
        padding: EdgeInsets.only(
            left: _sizeUtils.xasisSobreYasis * 0.05,
            right: _sizeUtils.xasisSobreYasis * 0.05,
            bottom: _sizeUtils.xasisSobreYasis * 0.025),
        child: BlocBuilder<VisitsBloc, VisitsState>(
          builder: (visitsContext, state) {
            if(state is OnVisitDetail){
              return _createLoadedVisitChild(state);
            }else{
              _loadChosenVisit(visitsContext);
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _createLoadedVisitChild(OnVisitDetail state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTop(),
        PageTitle(title: state.visit.name, underlined: false),
        SizedBox(height: _sizeUtils.veryLittleSizedBoxHeigh),
        _createInitFullDate(),
      ],
    );
  }

  void _loadChosenVisit(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<VisitsBloc>(context).add(LoadChosenVisit());
    });
  }

  Widget _createTop() {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_createBackButton(), LogoutButton()],
      ),
    );
  }

  Widget _createBackButton() {
    return hasBackButton
        ? AppBackButton(withLeftMargin: false)
        : Container(
            height: _sizeUtils.largeSizedBoxHeigh, color: Colors.transparent);
  }

  Widget _createInitFullDate() {
    return Row(
      children: [
        _createFullDateChild('Fecha: ${_formulario.initialDate}'),
        _createVerticalDivider(),
        _createFullDateChild('Hora inicio: ${_formulario.initialTime}')
      ],
    );
  }

  Widget _createFullDateChild(String fullDateChild) {
    return Expanded(
      child: Text(
        fullDateChild,
        style: TextStyle(
            color: Theme.of(_context).primaryColor,
            fontSize: _sizeUtils.normalTextSize),
      ),
    );
  }

  Widget _createVerticalDivider() {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.02),
      color: Theme.of(_context).primaryColor,
      width: 1,
      height: _sizeUtils.xasisSobreYasis * 0.03,
    );
  }
}
