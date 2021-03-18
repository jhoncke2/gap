import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class FormulariosPage extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FormulariosBloc, FormulariosState>(
          builder: (_, state) {
            if(state.formsAreLoaded && !state.backing){
              return _createContent(state);
            }else{
              return _createLoadingWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _createContent(FormulariosState state){
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 500)),
      builder: (_, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else
          return _createLoadedContent(state);
      },
    );
  }

  Widget _createLoadedContent(FormulariosState state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
        Header(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _FormulariosComponents(visitForms: state.forms)
      ],
    );
  }

  Widget _createLoadingWidget() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan[600],
          strokeWidth: 7.5,
        ),
      ),
    );
  }

}

// ignore: must_be_immutable
class _FormulariosComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<Formulario> visitForms;
  Visit visit;
  BuildContext _context;
  _FormulariosComponents({
    @required this.visitForms
  });

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.95,
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: this.visit.name, underlined: false),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createDate(),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          NavigationListWithStageButtons(itemsFunction: _onItemTap, entitiesWithStages: visitForms),
        ],
      )
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    final VisitsBloc vBloc = BlocProvider.of<VisitsBloc>(appContext);
    this.visit = vBloc.state.chosenVisit;
  }

  Widget _createDate(){
    return Container(   
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.03),
      child: Text(
        visit.date.toString().split(' ')[0],
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: _sizeUtils.subtitleSize,
          color: Theme.of(_context).primaryColor
        ),
      ),
    );
  }

  void _onItemTap(EntityWithStage entity){
    PagesNavigationManager.navToFormDetail(entity, _context);
  }
}