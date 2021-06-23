import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_app_scaffold.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/progress_indicator.dart';
import 'package:gap/clean_architecture_structure/features/formularios/presentation/bloc/formularios_bloc.dart';
import 'package:gap/clean_architecture_structure/features/formularios/presentation/widgets/loaded_formularios.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class FormulariosPage extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();

  @override
  Widget build(BuildContext context) {
    return GeneralAppScaffold(
      providers: [
        BlocProvider<VisitsBloc>(create: (_)=>sl()),
        BlocProvider<FormulariosBloc>(create: (_)=>sl())
      ],
      createChild: ()=> SafeArea(
        child: Column(
          children: [
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            PageHeader(
              //TODO: Implementar lo que se necesite
            ),
            BlocBuilder<FormulariosBloc, FormulariosState>(
              builder: (formsContext, state) {
                if(state is FormulariosEmpty){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    BlocProvider.of<FormulariosBloc>(formsContext).add(LoadFormularios());
                  });
                }else if(state is OnCompletedFormularios){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    PagesNavigationManager.initFirstFirmerFillingOut();
                  });
                }else if(state is OnLoadedFormularios){
                  return _createContent(state);
                }else if(state is OnFormularioSelected){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    PagesNavigationManager.navToFormDetail(FormularioOld.fromFormularioNew(state.formulario));
                  });
                }
                return CustomProgressIndicator(
                  heightScreenPercentage: 0.75
                );
              },
            ),
          ],
        ),
      )
    );
  }

  Widget _createContent(OnLoadedFormularios state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        LoadedFormularios(formularios: state.formularios)
      ],
    );
  }
}