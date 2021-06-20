import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'draw_detector.dart';
import 'firm_paint.dart';

// ignore: must_be_immutable
class FirmField extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final PersonalInformationOld firmer;
  BuildContext _context;
  FirmField({
    @required this.firmer
  });

  @override
  Widget build(BuildContext context){
    _context = context;
    return Container(
      child: Column(
        children:[
          _createTitle(),
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.1),
          //TODO: Revisar documentación y probar que sirva
          _createPainter(),
          _createFirmBotLine()
        ],
      ),
    );
  }

  Widget _createTitle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Text(
          'Firma',
          style: TextStyle(
            color: Theme.of(_context).primaryColor,
            fontSize: _sizeUtils.subtitleSize
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.cancel
          ),
          color: Colors.redAccent.withOpacity(0.8),
          onPressed: _onResetButtonPressed
        )
      ],
    );
  }

  void _onResetButtonPressed(){
    BlocProvider.of<FirmPaintBloc>(_context).add(ResetFirmPaint());
  }

  Widget _createPainter(){
    final Size fieldSize = Size(double.infinity, _sizeUtils.xasisSobreYasis * 0.21);
    print(fieldSize);
    return Container(
      width: fieldSize.width,
      height: fieldSize.height,
      child: Stack(
        children: [
          FirmPaint(size: fieldSize),
          DrawDetector(size: fieldSize)
        ]
      ),
    );
  }
  

  Widget _createFirmBotLine(){
    return Divider(
      color: Theme.of(_context).primaryColor.withOpacity(0.5),
      thickness: 3,
      height: 3,
    );
  }
}