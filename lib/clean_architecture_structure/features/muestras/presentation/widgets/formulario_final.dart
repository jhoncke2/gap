import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/widgets/formulario_view.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
class FormularioFinal extends StatelessWidget {
  final Formulario formulario;
  const FormularioFinal({
    @required this.formulario,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormularioView(
      formulario: formulario, 
      onEnd: (Formulario formulario){
        //TODO: Implementar primer linea y quitar demás cuando se haya implementado clean architecture en formularios
        BlocProvider.of<MuestrasBloc>(context).add(EndFinalFormulario(formulario: formulario));
        //PagesNavigationManager.navToForms();
      }
    );
  }
}