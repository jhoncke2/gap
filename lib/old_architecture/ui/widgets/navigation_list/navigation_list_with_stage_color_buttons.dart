import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/button/button_with_stage_color.dart';
import 'package:gap/old_architecture/ui/widgets/navigation_list/navigation_list.dart';
// ignore: must_be_immutable
class NavigationListWithStageButtons extends NavigationList{
  final List<EntityWithStageOld> entitiesWithStages;
  final Function(EntityWithStageOld entity) itemsFunction;
  final Widget Function(EntityWithStageOld entity) itemTileFunction;
  final String Function(EntityWithStageOld entity) getItemButtonText;
  
  NavigationListWithStageButtons({
    @required this.entitiesWithStages,
    @required this.itemsFunction,
    this.itemTileFunction,
    this.getItemButtonText
  }) : super(
    itemsNames:[],
    itemsFunctions:[],
    scrollIsAllwaysShown: true
  );

  @override
  List<Widget> createButtonItems(){
    final List<Widget> items = entitiesWithStages.map<Widget>((EntityWithStageOld entity){
      final String buttonText = (getItemButtonText==null)? entity.name : getItemButtonText(entity);
      Widget tile = (itemTileFunction==null)? null : itemTileFunction(entity);
      return ButtonWithStageColor(
        name: buttonText,
        textColor: Theme.of(context).primaryColor,
        stage: entity.stage,
        tile: tile,
        onTap: (){itemsFunction(entity);}, 
        
      );
    }).toList();
    return items;
  }
}