import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/native_back_button_locker.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/navigation_list_with_icons.dart';

// ignore: must_be_immutable
class VisitDetailPageOld extends StatelessWidget {
  static final String route = 'visit_detail';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: NativeBackButtonLocker(
        child: SafeArea(
          child: BlocBuilder<VisitsOldBloc, VisitsState>(
            builder: (context, state) {
              if(state.chosenVisitIsBlocked)
                return CustomProgressIndicator();
              else
                return _createLoadedComponents(state.chosenVisit);
            },
          ),
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext) {
    _context = appContext;
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createLoadedComponents(VisitOld chosenVisit){
    return Column(
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        PageHeader(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createBodyComponents(chosenVisit)
      ],
    );
  }

  Widget _createBodyComponents(VisitOld chosenVisit){
    if(chosenVisit != null)
      return _VisitDetailComponents(visit: chosenVisit);
    else
      return CustomProgressIndicator(heightScreenPercentage: 0.5);
  }
}

// ignore: must_be_immutable
class _VisitDetailComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final VisitOld visit;
  BuildContext _context;
  _VisitDetailComponents({@required this.visit});

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _sizeUtils.normalHorizontalScaffoldPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitle(title: visit.name, underlined: false),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createDateText(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            NavigationListWithIcons(
              currentVisitProcessState: visit.stage,
            )
          ],
        ));
  }

  Widget _createDateText() {
    final DateTime date = visit.date;
    return Text(
      'Fecha: ${date.toString().split(' ')[0]}',
      style: TextStyle(
          color: Theme.of(_context).primaryColor,
          fontSize: _sizeUtils.normalTextSize),
    );
  }
}
