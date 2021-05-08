import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/bloc/muestras_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class RangoEdadChosing extends StatefulWidget {
  final Muestra muestra;

  RangoEdadChosing({
    @required this.muestra,
    Key key
  }) : super(key: key);

  @override
  _RangoEdadChosingState createState() => _RangoEdadChosingState();
}

class _RangoEdadChosingState extends State<RangoEdadChosing> {
  final SizeUtils sizeUtils = SizeUtils();

  int _currentSelectedPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 35),
            child: Text(
              'Elige un rango de edad',
              style: TextStyle(
                fontSize: sizeUtils.subtitleSize
              ),
            ),
          ),
          _createRangoChooser(context),
          _createContinueButton(context)
        ],
      ),
    );
  }

  Widget _createRangoChooser(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: _createMainContainerDecoration(context),
      child: DropdownButton<int>(
        items: _createItems(),
        selectedItemBuilder: (_)=>widget.muestra.rangos.map((rango) => Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Center(
            child: Text(
              rango, 
              textAlign: TextAlign.center,
            ),
          )
        )).toList(),
        value: _currentSelectedPosition,
        onChanged: _onChanged,
      ),
    );
  }

  BoxDecoration _createMainContainerDecoration(BuildContext context){
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).primaryColor,
        width: 1.0
      ),
      borderRadius: BorderRadius.circular(25)
    );
  }

  void _onChanged(int newPosition){
    setState(() {
      _currentSelectedPosition = newPosition;
    });
  }

  List<DropdownMenuItem<int>> _createItems(){
    List<DropdownMenuItem<int>> menuItems = [];
    List<String> rangos = widget.muestra.rangos;
    for(int i = 0; i < rangos.length; i++){
      menuItems.add(DropdownMenuItem<int>(
        child: Text(rangos[i]),
        value: i,
      ));
    }
    return menuItems;
  }

  Widget _createContinueButton(BuildContext context){
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      child: GeneralButton(
        text: 'Continuar', 
        onPressed: _currentSelectedPosition== null? null : ()=>_continue(context), 
        backgroundColor: Theme.of(context).primaryColor
      ),
    );
  }

  void _continue(BuildContext context){
    BlocProvider.of<MuestrasBloc>(context).add(ChooseRangoEdad(rango: widget.muestra.rangos[_currentSelectedPosition]));
  }
}