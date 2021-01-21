import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/forms/loaded_form_body.dart';
import 'package:gap/widgets/forms/loaded_form_head.dart';
import 'package:gap/widgets/header/header.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_nav_items.dart';

// ignore: must_be_immutable
class FormularioDetailPage extends StatelessWidget {
  static final String route = 'formulario_detail';
  final SizeUtils _sizeUtils = SizeUtils();
  FormularioDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final viewPadding = MediaQuery.of(context).viewPadding;
    print(padding);
    print(viewPadding);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeArea(child: Container()),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              Header(),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createFormBuilder()
            ],
            ),
        ),
      )
    );
  }

  Widget _createFormBuilder(){
    return BlocBuilder<FormulariosBloc, FormulariosState>(
      builder: (context, state) {
        if(state.chosenForm != null){          
          return _LoadedFormularioDetail(formsState: state);
        }else{
          return UnloadedNavItems();
        }
      },
    );
  }
}

/**
 * Column(
children: [
  SafeArea(child: Container()),
  SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
  Header(),
  SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
  _createFormBuilder()
],
),
 */

// ignore: must_be_immutable
class _LoadedFormularioDetail extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final FormulariosState formsState;
  _LoadedFormularioDetail({
    @required this.formsState
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _sizeUtils.xasisSobreYasis * 1.05,
      margin: EdgeInsets.all(0),
      child: Column(
        children: [
          LoadedFormHead(formsState: formsState),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          LoadedFormBody(formsState: formsState)
        ],
      )
    );
  }
}