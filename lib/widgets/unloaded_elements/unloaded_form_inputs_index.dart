import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class UnloadedFormInputsIndex extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  UnloadedFormInputsIndex();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.0375,
      width: _sizeUtils.xasisSobreYasis * 0.4875,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createLittleElement(0.129, 0.035),
          _createLittleElement(0.0275, 0.035),
          _createLittleElement(0.0275, 0.035),
          _createLittleElement(0.0275, 0.035),
          _createSuspensiveDots(),
          _createLittleElement(0.0275, 0.035),
          _createLittleElement(0.129, 0.035),
        ],
      ),
    );
  }

  Widget _createLittleElement(double widthPercent, double heightPercent){
    return Container(
      width: _sizeUtils.xasisSobreYasis * widthPercent,
      height: _sizeUtils.xasisSobreYasis * heightPercent,
      decoration: BoxDecoration(
        color: Theme.of(_context).primaryColor.withOpacity(0.75),
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045)
      ),
    );
  }

  Widget _createSuspensiveDots(){
    return Text(
      '...',
      style: TextStyle(
        fontSize: _sizeUtils.subtitleSize,
        color: Theme.of(_context).primaryColor
      ),
    );
  }
}