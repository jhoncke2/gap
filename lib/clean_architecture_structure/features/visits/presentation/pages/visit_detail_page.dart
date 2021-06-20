import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list_with_icons.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/page_title.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_app_scaffold.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class VisitDetailPage extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  const VisitDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralAppScaffold(
      providers: [
        BlocProvider<VisitsBloc>( create: (context) => sl() )
      ],
      createChild: ()=>SafeArea(
        child: Column(
          children: [
            PageHeader(),
            SizedBox(height: sizeUtils.normalSizedBoxHeigh),
            _createVisitsBlocBuilder()
          ],
        ),      
      ),
    );
  }

  Widget _createVisitsBlocBuilder(){
    return BlocBuilder<VisitsBloc, VisitsState>(
      builder: (context, state){
        if(state is VisitsEmpty){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            BlocProvider.of<VisitsBloc>(context).add(LoadChosenVisit());
          });
        }else if(state is LoadingVisits){
          return CustomProgressIndicator(heightScreenPercentage: 0.8);
        }else if(state is OnVisitDetail){
          return LoadedVisitDetailComponent(visit: state.visit);
        }
        return Container();
      }
    );
  }
}

class LoadedVisitDetailComponent extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  final Visit visit;
  const LoadedVisitDetailComponent({
    @required this.visit,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeUtils.normalHorizontalScaffoldPadding
      ),
      child: Column(
        children: [
          PageTitle(title: visit.name, underlined: false),
          SizedBox(height: sizeUtils.normalSizedBoxHeigh),
          _createDateText(context),
          SizedBox(height: sizeUtils.normalSizedBoxHeigh),
          VisitNavigationList(visit: this.visit)
        ],
      ),
    );
  }

  Widget _createDateText(BuildContext context) {
    final DateTime date = visit.date;
    return Text(
      'Fecha: ${date.toString().split(' ')[0]}',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: sizeUtils.normalTextSize
      ),
    );
  }
}