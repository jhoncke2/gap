import 'package:flutter/material.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:gap/ui/utils/size_utils.dart';
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
        color: Theme.of(_context).primaryColor
      ),
    );
  }

  Widget _createPainter(){
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.2,
      child: CustomPaint(

      ),
    );
  }

  Widget _createFirmBotLine(){
    return Divider(
      color: Theme.of(_context).primaryColor.withOpacity(0.5),
      height: 3,
    );
  }
}