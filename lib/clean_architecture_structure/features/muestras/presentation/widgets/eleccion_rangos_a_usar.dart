import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class EleccionRangosAUsar extends StatefulWidget {
  final List<Rango> rangos;
  EleccionRangosAUsar({
    @required this.rangos,
    Key key
  }) : super(key: key);

  @override
  _EleccionRangosAUsarState createState() => _EleccionRangosAUsarState();
}

class _EleccionRangosAUsarState extends State<EleccionRangosAUsar> {
  final SizeUtils sizeUtils = SizeUtils();
  List<bool> rangosSelection;
  List<int> selectedValues;

  @override
  void initState() {
    selectedValues = [];
    rangosSelection = widget.rangos.map(
      (_) => false
    ).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Elige las clasificaciones que vas a usar',
            style: TextStyle(
              fontSize: sizeUtils.subtitleSize
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.175),
              itemCount: widget.rangos.length,
              itemBuilder: (_, int index)=>_onItemCreated(index)
            ),
          ),
          _crateContinueButton()
        ],
      ),
    );
  }

  Widget _onItemCreated(int index){
    Rango rango = widget.rangos[index];
    return Container(
      width: sizeUtils.xasisSobreYasis * 0.25,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: CheckboxListTile(
        key: Key('${rango.id}_checkboxtile'),
        title: Text(
          rango.nombre,
          style: TextStyle(
            color: rangosSelection[index]? Colors.redAccent[600] : Theme.of(context).primaryColor,
            fontSize: sizeUtils.normalTextSize
          ),
        ), 
        value: rangosSelection[index],
        onChanged: (bool isSelected){
           setState((){
             rangosSelection[index] = isSelected;
          });
        }
      ),
    );
  }

  Widget _crateContinueButton(){
    return Container(
      child: GeneralButton(
        text: 'Continuar', 
        onPressed: rangosSelection.contains(true)? _continuar : null, 
        backgroundColor: Theme.of(context).primaryColor
      ),
      margin: EdgeInsets.only(bottom: 15),
    );
  }

  void _continuar(){
    List<Rango> rangosAUsar = [];
    for(int i = 0; i < widget.rangos.length; i++)
      if(rangosSelection[i])
        rangosAUsar.add(widget.rangos[i]);
    BlocProvider.of<MuestrasBloc>(context).add(ChooseRangosAUsar(rangos: rangosAUsar));
  }

}