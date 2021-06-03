import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class PreparacionComponentes extends StatefulWidget {
  final Muestreo muestra;

  PreparacionComponentes({
    @required this.muestra,
    Key key
  }): super(key: key);

  @override
  _PreparacionComponentesState createState() => _PreparacionComponentesState();
}

class _PreparacionComponentesState extends State<PreparacionComponentes> {
  final SizeUtils sizeUtils = SizeUtils();
  final List<TextEditingController> preparacionesControllers = [];

  @override
  void initState() { 
    super.initState();
    preparacionesControllers.addAll( 
      widget.muestra.componentes.map((_) => TextEditingController())
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        //color: Colors.grey.withOpacity(0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //_createComponenteAndPreparacionTable(),
            _createTable(),
            _createContinueButton()
          ],
        ),
      ),
    );
  }

  Widget _createTable(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Table(
        children: _createRows(),
        border: TableBorder(
          //verticalInside: BorderSide(color: Colors.grey.withOpacity(0.5)),
          //horizontalInside: BorderSide(color: Colors.grey.withOpacity(0.5)),
        )
      ),
    );
  }

  List<TableRow> _createRows(){
    List<TableRow> rows = [ 
      TableRow(
        children: [
          _createTopCell('Componente'),
          _createTopCell('Preparación'),
        ]
      ) 
    ];
    for(int i = 0; i < widget.muestra.componentes.length; i++)
      rows.add(_createComponenteRow(i));
    return rows;
  }

  Widget _createTopCell(String texto){
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: sizeUtils.subtitleSize * 0.9,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  TableRow _createComponenteRow(int index){
    final Componente componente = widget.muestra.componentes[index];
    return TableRow(
      children:[
        Container(
          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              componente.nombre,
              style: TextStyle(
                fontSize: sizeUtils.normalTextSize
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
            key: Key(componente.nombre + '$index'),
            controller: preparacionesControllers[index],
            decoration: InputDecoration(
              //filled: true,
              //fillColor: Colors.grey.withOpacity(0.25),
              border: _createInputBorder()
            )
          ),
        ),
      ]
    );
  }

  InputBorder _createInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(sizeUtils.xasisSobreYasis * 0.03),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.85),
        width: 3
      )
    );
  }

  Widget _createContinueButton(){
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: GeneralButton(
        text: 'Continuar',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          List<String> preparaciones = preparacionesControllers.map((c) => c.text).toList();
          BlocProvider.of<MuestrasBloc>(context).add(SetMuestreoPreparaciones(preparaciones: preparaciones));
        },
      ),
    );
  }
}