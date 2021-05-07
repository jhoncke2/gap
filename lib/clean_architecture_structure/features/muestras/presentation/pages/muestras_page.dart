import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_keyboard_detector.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class MuestrasPage extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  MuestrasPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sizeUtils.initUtil(MediaQuery.of(context).size);
    return ScaffoldKeyboardDetector(
      child: SafeArea(
        child: BlocProvider<MuestrasBloc>(
          create: (context) => sl(),
          child: Container(
            child: _createMuestrasBlocBuilder(),
          ),
        ),
      ),
    );
  }

  Widget _createMuestrasBlocBuilder(){
    return BlocBuilder<MuestrasBloc, MuestrasState>(
      builder: (context, state) {
        return Column(
          children: [
            PageHeader(),
            _createBlocBuilderBottom(state)
          ],
        );
      },
    );
  }

  Widget _createBlocBuilderBottom(MuestrasState state){
    return Container();
  }
}
