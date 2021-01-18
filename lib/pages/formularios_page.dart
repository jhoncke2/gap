import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/formularios/formularios_bloc.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_nav_items.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/utils/test/formularios.dart' as fakeFormularios;
// ignore: must_be_immutable
class FormulariosPage extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: _createComponents(),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
  }

  Widget _createComponents(){
    return BlocBuilder<FormulariosBloc, FormulariosState>(
      builder: (_, state) {
        if(state.formsAreLoaded){
          return Container(
            height: 200,
            width: 200,
            color: Colors.redAccent,
          );
        }else{
          return UnloadedNavItems();
        }
      },
    );
  }


}