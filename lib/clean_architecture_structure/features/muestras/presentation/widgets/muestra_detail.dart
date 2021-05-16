import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class MuestraDetail extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  final Muestra muestra;
  final List<Componente> muestreoComponentes;
  MuestraDetail({
    @required this.muestra,
    @required this.muestreoComponentes,    
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.2), 
        ),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(),
          MuestraDetailTable(muestra: muestra, muestreoComponentes: muestreoComponentes),
          _createBottomButtons(context)
        ],
      ),
    );
  }

  Widget _createBottomButtons(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.cancel
          ),
          iconSize: sizeUtils.largeIconSize,
          color: Colors.blueGrey.withOpacity(0.75),
          onPressed: (){
            BlocProvider.of<MuestrasBloc>(context).add(BackFromMuestraDetail());
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete_rounded
          ),
          iconSize: sizeUtils.largeIconSize,
          color: Colors.redAccent.withOpacity(0.75),
          onPressed: (){
            BlocProvider.of<MuestrasBloc>(context).add(RemoveMuestraEvent());
          },
        )
      ],
    );
  }
}

class MuestraDetailTable extends StatelessWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  final Muestra muestra;
  final List<Componente> muestreoComponentes;
  const MuestraDetailTable({
    @required this.muestra,
    @required this.muestreoComponentes,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.only(left: 20),
      child: Center(
        child: SingleChildScrollView(
          child: Table(
            children: _createRows(),
          ),
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
    for(int i = 0; i < muestreoComponentes.length; i++)
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
    final Componente componente = muestreoComponentes[index];
    return TableRow(
      children:[
        _createTableCell( componente.nombre ),
        _createTableCell( muestra.pesos[index].toString() )
      ]
    );
  }

  Widget _createTableCell(String text){
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: sizeUtils.normalTextSize
          ),
        ),
      ),
    );
  }
}