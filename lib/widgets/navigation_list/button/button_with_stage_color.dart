import 'package:flutter/material.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/navigation_list/button/navigation_list_button.dart';
// ignore: must_be_immutable
class ButtonWithStageColor extends NavigationListButton{
  final SizeUtils _sizeUtils = SizeUtils();
  final ProcessStage stage;
  ButtonWithStageColor({
    @required String name,
    @required Color textColor,
    @required Function onTap,
    @required this.stage
  }):super(
    hasBottomBorder: true,
    name: name,
    textColor: textColor,
    onTap: onTap
  );

  @override
  Widget build(BuildContext context) {
    initInitialConfiguration(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.03),
      child: Row(
        children: [
          _createCircleForStageColor(),
          SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
          _createRightItem(),
        ],
      ),
    );
  }

  Widget _createCircleForStageColor(){
    final Color circleColor = (stage == ProcessStage.Pendiente)? 
      Color.fromRGBO(213, 199, 18, 1)
      : Color.fromRGBO(142, 180, 22, 1);
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.0175,
      height: _sizeUtils.xasisSobreYasis * 0.0175,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor
      ),
    );
  }

  Widget _createRightItem(){
    return Expanded(
      child: createButton()  
    );
  }
}