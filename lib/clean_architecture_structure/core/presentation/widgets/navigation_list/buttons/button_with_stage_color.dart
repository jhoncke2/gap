import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class ButtonWithStageColor extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final Widget rightChild;
  final String name;
  final Color textColor;
  final Function onTap;
  final ProcessStage stage;
  ButtonWithStageColor({
    String name,
    @required this.textColor,
    @required this.onTap,
    @required this.stage,
    Widget rightChild
  }):
    this.name = name,
    this.rightChild = rightChild,
    assert(
      name == null || rightChild == null
    );

  @override
  Widget build(BuildContext context) {
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
        child: NavigationListButton(
          child: this.rightChild ?? _createButtonName(),
          textColor: this.textColor,
          onTap: this.onTap,
          hasBottomBorder: true,
        )  
      ); 
  }

  Widget _createButtonName(){
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: _sizeUtils.littleTitleSize,
        color: textColor
      ),
    );
  }
}