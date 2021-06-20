import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/widgets/header/page_header.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable

class FormulariosPageOld extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<VisitsBloc>(
        create: (context) => sl(),
        child: NativeBackButtonLocker(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
                PageHeaderOld(
                  onBackButtonTap: _onBack,
                ),
                BlocBuilder<FormulariosOldBloc, FormulariosState>(
                  builder: (_, state) {
                    if (state.formsAreLoaded &&
                        !state.backing &&
                        !state.formsAreBlocked) {
                      return _createContent(state);
                    } else {
                      return CustomProgressIndicator(
                          heightScreenPercentage: 0.75);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBack() {
    PagesNavigationManager.endForms();
  }

  Widget _createContent(FormulariosState state) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 500)),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        else
          return _createLoadedContent(state);
      },
    );
  }

  Widget _createLoadedContent(FormulariosState state) {
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
  _FormulariosComponents({@required this.visitForms});

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
        NavigationListWithStageButtons(
            itemsFunction: _onItemTap, 
            entitiesWithStages: visitForms),
      ],
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

  void _onItemTap(EntityWithStageOld entity) {
    PagesNavigationManager.navToFormDetail(entity);
  }
}