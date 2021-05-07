import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/header/page_header.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_keyboard_detector.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
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
        _addInitialMuestrasBlocPostFrameCall(context, state);
        return Column(
          children: [
            PageHeader(
              withTitle: (state is LoadedMuestra),
              title: (state is LoadedMuestra)? 'Muestra ${state.muestra.tipo}': null
            ),
            SizedBox(height: sizeUtils.xasisSobreYasis * 0.05),
            Expanded(
              child: _createBlocBuilderBottom(state)
            )
          ],
        );
      },
    );
  }

  void _addInitialMuestrasBlocPostFrameCall(BuildContext context, MuestrasState state){
    if(state is MuestraEmpty)
      _addInitialMuestrasBlocPostFrameCallIfMuestrasIsEmpty(context);
  }

  void _addInitialMuestrasBlocPostFrameCallIfMuestrasIsEmpty(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      BlocProvider.of<MuestrasBloc>(context).add( GetMuestraEvent() );
    });
  }

  Widget _createBlocBuilderBottom(MuestrasState state){
    if(state is LoadedMuestra)
      return OnPreparacion(muestra: state.muestra);
    return Container();
  }
}

class OnPreparacion extends StatelessWidget {
  final Muestra muestra;
  OnPreparacion({
    @required this.muestra,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //color: Colors.grey.withOpacity(0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createComponenteAndPreparacionTable(),
          _createContinueButton(context)
        ],
      ),
    );
  }

  Widget _createComponenteAndPreparacionTable(){
    return DataTable(
      columns: [
        DataColumn(label: Text('Componente')),
        DataColumn(label: Text('Preparación'))
      ],
      rows: _createTableRows(),
    );
  }

  List<DataRow> _createTableRows(){
    return muestra.componentes.map(
      (c)=>DataRow(
        cells: [
          DataCell(
            Text(c.nombre)
          ),
          DataCell(
            Text('Aquí va la respuesta')
          )
        ]
      )
    ).toList();
  }

  Widget _createContinueButton(BuildContext context){
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: GeneralButton(
        text: 'Continuar',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){},
      ),
    );
  }
}