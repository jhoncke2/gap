import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/widgets/buttons/general_button.dart';
import 'package:gap/widgets/header/header.dart';
import 'package:gap/widgets/page_title.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/utils/dialogs.dart' as dialogs;

// ignore: must_be_immutable
class AdjuntarFotosVisitaPage extends StatelessWidget {
  static final String route = 'adjuntar_fotos_visit';
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  AdjuntarFotosVisitaPage();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            Header(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createBottomItems()
          ],
        ),
      ),
    );
  }

  Widget _createBottomItems() {
    return Container(
      width: MediaQuery.of(_context).size.width,
      height: _sizeUtils.xasisSobreYasis * 1.025,
      padding: EdgeInsets.symmetric(
      horizontal: _sizeUtils.normalHorizontalScaffoldPadding),
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createTopComponents(state),
              _createEndButton()
            ],
          );
        },
      ),
    );
  }

  Widget _createTopComponents(VisitsState state){
    return Container(
      child: Column(
        children: [
          PageTitle(title: 'Adjuntar fotos', underlined: false),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          _createAdjuntarFotosButton(),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          _createTextoSecundario(state.chosenVisit.name),
        ],
      ),
    );
  }

  Widget _createAdjuntarFotosButton(){
    return GeneralButton(
      text: 'Adjuntar fotos a visita', 
      onPressed: _onAdjuntarPressed, 
      backgroundColor: Theme.of(_context).secondaryHeaderColor,
      borderShape: BtnBorderShape.Circular,
    );
  }

  void _onAdjuntarPressed(){
    dialogs.showAdjuntarFotosDialog(_context);
  }

  Widget _createTextoSecundario(String visitName){
    return Text(
      'Fotos adjuntadas a la visita: $visitName',
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.normalTextSize
      ),
    );
  }

  Widget _createEndButton(){
    return Container(
      margin: EdgeInsets.only(bottom: _sizeUtils.xasisSobreYasis * 0.1),
      child: GeneralButton(
        text: 'Finalizar',
        backgroundColor: Theme.of(_context).secondaryHeaderColor,
        onPressed: (){},
      ),
    );
  }
}