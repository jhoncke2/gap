import 'package:flutter/material.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/draw_detector.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/firm_paint.dart';
// ignore: must_be_immutable
class FirmField extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final PersonalInformation firmer;
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
          SizedBox(height: _sizeUtils.littleSizedBoxHeigh),
          //TODO: Revisar documentación y probar que sirva
          _createPainter(),
          _createFirmBotLine()
        ],
      ),
    );
  }

  Widget _createTitle(){
    return Text(
      'Firma',
      style: TextStyle(
        color: Theme.of(_context).primaryColor,
        fontSize: _sizeUtils.subtitleSize
      ),
    );
  }

  Widget _createPainter(){
    final Size fieldSize = Size(double.infinity, _sizeUtils.xasisSobreYasis * 0.21);
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