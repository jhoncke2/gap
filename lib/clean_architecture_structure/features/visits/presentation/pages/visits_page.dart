import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_native_back_button_locker.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/widgets/loaded_visits.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class VisitsPage extends StatelessWidget {
  static final _sizeUtils = SizeUtils();
  VisitsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldNativeBackButtonLocker(
        child: BlocProvider<VisitsBloc>(
          create: (context) => sl(),
          child: SafeArea(
            child: Container(child: _createBodyComponents()),
          ),
        ),
      ),
    );
  }

  Widget _createBodyComponents() {
    return Column(
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        PageHeader(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createVisitStateComponents()
      ],
    );
  }

  Widget _createVisitStateComponents() {
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.9,
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (context, VisitsState state){
          if(state is VisitsEmpty){
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              BlocProvider.of<VisitsBloc>(context).add(LoadVisits());
            });
          }else if (state is OnVisits) {
            return LoadedVisits(visits: state.visits);
          }
          return _createLoadingIndicator();
          
        },
      ),
    );
  }

  Widget _createLoadingIndicator() {
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
