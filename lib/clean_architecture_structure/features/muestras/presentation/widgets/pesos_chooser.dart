import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

class PesosChooser extends StatefulWidget {

  final Muestreo muestra;
  final String rangoEdad;
  PesosChooser({
    @required Muestreo muestra,
    @required int rangoEdadIndex,
    Key key
  }) : 
    this.muestra = muestra,
    this.rangoEdad = muestra.stringRangos[rangoEdadIndex],
    super(key: key);

  @override
  _PesosChooserState createState() => _PesosChooserState();
}

class _PesosChooserState extends State<PesosChooser> {
  final SizeUtils sizeUtils = SizeUtils();
  final List<TextEditingController> pesosControllers = [];

  @override
  void initState() { 
    super.initState();
    pesosControllers.addAll( 
      widget.muestra.componentes.map((_) => TextEditingController())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Padding(
             padding: const EdgeInsets.only(top: 25),
             child: Text(
               'Rango de edad: ${widget.rangoEdad}',
               style: TextStyle(
                 fontSize: sizeUtils.subtitleSize
               ),
             ),
           ),
           _createTable(),
           _createContinueButton(context)
         ],
       ),
    );
  }

  Widget _createTable(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Table(
          children: _createRows(),
        ),
      ),
    );
  }

  List<TableRow> _createRows(){
    List<TableRow> rows = [
      TableRow(
        children: [
          _createTopCell('Componente'),
          _createTopCell('Peso registrado'),
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
    final double pesoEsperado = _getPesoEsperadoFromComponenteIndex(index);
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
            controller: pesosControllers[index],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: ((pesoEsperado == null)? '' : 'Esperado: $pesoEsperado' ) ,
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.6)
              ),
              border: _createInputBorder()
            )
          ),
        ),
      ]
    );
  }

  double _getPesoEsperadoFromComponenteIndex(int componenteIndex){
    int rangoIndex = widget.muestra.stringRangos.indexWhere((r) => r == widget.rangoEdad);
    return widget.muestra.pesosEsperadosPorRango[rangoIndex][componenteIndex];
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

  Widget _createContinueButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: GeneralButton(
        text: 'Continuar',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _canContinue()? ()=>_continue(context) : null
      ),
    );
  }

  bool _canContinue(){
    for(TextEditingController pC in pesosControllers)
      if([null, ''].contains(pC.text))
        return false;
    return true;
  }

  void _continue(BuildContext context){
    BlocProvider.of<MuestrasBloc>(context).add(AddMuestraPesos(
      pesos: pesosControllers.map((p) => p.text).toList()
    ));
  }
}