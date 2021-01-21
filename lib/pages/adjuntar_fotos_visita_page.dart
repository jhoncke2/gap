import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/header/header.dart';
import 'package:gap/widgets/page_title.dart';

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
      padding: EdgeInsets.symmetric(
      horizontal: _sizeUtils.normalHorizontalScaffoldPadding),
      child: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(title: 'Adjuntar fotos', underlined: false),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createAdjuntarButton(),
              SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
              _createTextoSecundario(state.chosenVisit.name)
            ],
          );
        },
      ),
    );
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

  Widget _createAdjuntarButton(){
    return MaterialButton(
      color: Colors.brown.withOpacity(0.35),
      child: Text(
        'Adjuntar fotos a visita',
        style: TextStyle(
          color: Colors.white
        ),
      ),
      onPressed: (){

      }
    );
  }
}
