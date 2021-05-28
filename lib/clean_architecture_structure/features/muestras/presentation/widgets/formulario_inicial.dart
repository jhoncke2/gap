import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/formulario_view.dart';

// ignore: must_be_immutable
class FormularioInicial extends StatelessWidget{
  final Formulario formulario;
  BuildContext context;
  FormularioInicial({@required this.formulario, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormularioView(
      formulario: formulario, 
      onEnd: (Formulario formulario){
        BlocProvider.of<MuestrasBloc>(context).add(EndInitialFormulario(formulario: formulario));
      }
    );
  }
}


