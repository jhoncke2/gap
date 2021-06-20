import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/button_with_stage_color.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/features/formularios/presentation/bloc/formularios_bloc.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class LoadedFormularios extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<Formulario> formularios;
  BuildContext _context;
  
  LoadedFormularios({@required this.formularios, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
        height: _sizeUtils.xasisSobreYasis * 0.95,
        padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
        child: BlocBuilder<VisitsBloc, VisitsState>(
          builder: (visitsBContext, state) {
            if(state is VisitsEmpty){
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                BlocProvider.of<VisitsBloc>(visitsBContext).add(LoadChosenVisit());
              });
            }else if(state is OnVisitDetail)
              return _createLoadedVisitChild(state);   
            return Container();
          },
        ));
  }

  Widget _createLoadedVisitChild(OnVisitDetail state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageTitle(title: state.visit.name, underlined: false),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createDate(state.visit.date),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        NavigationList(
          itemsLength: this.formularios.length, 
          createSingleNavButton: _createFormularioButton
        )
      ]
    );
  }

  Widget _createFormularioButton(int index) {
    final Formulario f = this.formularios[index];
    return ButtonWithStageColor(
      textColor: Theme.of(_context).primaryColor,
      onTap: () => _onTapFormulario(f),
      stage: f.stage,
      rightChild: _createShowedItemTile(f),
    ); 
  }

  void _onTapFormulario(Formulario f){
    BlocProvider.of<FormulariosBloc>(_context).add(SetChosenFormularioEvent(formulario: f));
  }

  Widget _createShowedItemTile(Formulario f) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            f.name,
            style: TextStyle(
                color: Theme.of(_context).primaryColor,
                fontSize: _sizeUtils.subtitleSize),
          ),
        ],
      ),
    );
  }

  Widget _createDate(DateTime date){
    return Container(
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.03),
      child: Text(
        date.toString().split(' ')[0],
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: _sizeUtils.subtitleSize,
            color: Theme.of(_context).primaryColor),
      ),
    );
  }
}