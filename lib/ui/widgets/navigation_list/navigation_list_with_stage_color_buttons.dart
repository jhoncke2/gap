import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/widgets/navigation_list/button/button_with_stage_color.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class NavigationListWithStageButtons extends NavigationList {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<EntityWithStage> entitiesWithStages;
  final Function(EntityWithStage entity) itemsFunction;
  NavigationListWithStageButtons({
    @required this.entitiesWithStages,
    @required this.itemsFunction
  }) : super(
    itemsNames:[],
    itemsFunctions:[],
  );

  @override
  List<Widget> createButtonItems(){
    final List<Widget> items = entitiesWithStages.map<Widget>((EntityWithStage entity){
      return ButtonWithStageColor(
        name: entity.name,
        textColor: Theme.of(context).primaryColor,
        stage: entity.stage,
        onTap: (){itemsFunction(entity);}, 
        
      );
    }).toList();
    return items;
  }
}