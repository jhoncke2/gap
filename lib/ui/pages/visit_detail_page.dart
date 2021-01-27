import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/models/entities/visit.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list_with_icons.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';

// ignore: must_be_immutable
class VisitDetailPage extends StatelessWidget {
  static final String route = 'visit_detail';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  
  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            Header(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createBodyComponents()
          ],
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _createBodyComponents(){
    return BlocBuilder<VisitsBloc, VisitsState>(
      builder: (_, state) {
        if(state.chosenVisit != null){          
          return _VisitDetailComponents(visit: state.chosenVisit);
        }else{
          return UnloadedNavItems();
        }
      },
    );
  }
}


// ignore: must_be_immutable
class _VisitDetailComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final Visit visit;
  BuildContext _context;
  _VisitDetailComponents({
    @required this.visit
  });

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.normalHorizontalScaffoldPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: visit.name, underlined: false),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createDateText(),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          NavigationListWithIcons(
            currentVisitProcessState: visit.currentStage, 
          )
        ],
      )
    );
  }

  Widget _createDateText(){
    final DateTime date = visit.date;
    return Text(
      'Fecha: ${date.toString().split(' ')[0]}',
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.normalTextSize
      ),
    );
  }
}