import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/models/EntityWithStages.dart';
import 'package:gap/widgets/navigation_list/button/button_with_stage_color.dart';
import 'package:gap/widgets/navigation_list/navigation_list.dart';
// ignore: must_be_immutable
class NavigationListWithStageButtons extends NavigationList {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<EntityWithStages> entitiesWithStages;
  final Function(EntityWithStages entity) itemsFunction;
  NavigationListWithStageButtons({
    @required this.entitiesWithStages,
    @required this.itemsFunction
  }) : super(
    itemsNames:[],
    itemsFunctions:[],
  );

  @override
  List<Widget> createButtonItems(){
    final List<Widget> items = entitiesWithStages.map<Widget>((EntityWithStages entity){
      return ButtonWithStageColor(
        name: entity.name,
        textColor: Theme.of(context).primaryColor,
        stage: entity.currentStage,
        onTap: (){itemsFunction(entity);}, 
        
      );
    }).toList();
    return items;
  }
}