import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/back_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/logout_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class FirmHead extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  final bool hasBackButton;
  BuildContext _context;

  FirmHead({@required this.formsState, this.hasBackButton = false});

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      color: Colors.grey.withOpacity(0.2),
      padding: EdgeInsets.only(
          left: _sizeUtils.xasisSobreYasis * 0.05,
          right: _sizeUtils.xasisSobreYasis * 0.05,
          bottom: _sizeUtils.xasisSobreYasis * 0.025),
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (visitsContext, state) {
          if(state is VisitsEmpty)
            _loadChosenVisit(visitsContext);
          else if(state is OnVisitDetail)
            return _createLoadedVisitChild(state);
          return Container();
        },
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
        _createInitFullDate(state.visit),
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

  Widget _createInitFullDate(Visit visit) {
    return Row(
      children: [
        _createFullDateChild('Fecha: ${visit.date.toString().split(' ')[0]}'),
      ]
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
}
