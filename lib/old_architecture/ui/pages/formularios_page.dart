import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/widgets/header/header.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/old_architecture/ui/widgets/page_title.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/progress_indicator.dart';
// ignore: must_be_immutable
class FormulariosPage extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: NativeBackButtonLocker(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
              Header(),
              BlocBuilder<FormulariosBloc, FormulariosState>(
                builder: (_, state) {
                  if(state.formsAreLoaded && !state.backing && !state.formsAreBlocked){
                    return _createContent(state);
                  }else{
                    return CustomProgressIndicator(heightScreenPercentage: 0.75);
                  }
                },
              ),
            ],
          ),
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
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _FormulariosComponents(visitForms: state.forms)
      ],
    );
  }

}

// ignore: must_be_immutable
class _FormulariosComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<FormularioOld> visitForms;
  VisitOld visit;
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

  void _onItemTap(EntityWithStageOld entity){
    PagesNavigationManager.navToFormDetail(entity, _context);
  }
}