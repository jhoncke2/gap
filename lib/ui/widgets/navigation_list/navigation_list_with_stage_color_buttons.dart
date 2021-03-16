import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/widgets/navigation_list/button/button_with_stage_color.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class NavigationListWithStageButtons extends NavigationList{
  final SizeUtils _sizeUtils = SizeUtils();
  final List<EntityWithStage> entitiesWithStages;
  final Function(EntityWithStage entity) itemsFunction;
  final Widget Function(EntityWithStage entity) itemTileFunction;
  final String Function(EntityWithStage entity) getItemButtonText;
  
  NavigationListWithStageButtons({
    @required this.entitiesWithStages,
    @required this.itemsFunction,
    this.itemTileFunction,
    this.getItemButtonText
  }) : super(
    itemsNames:[],
    itemsFunctions:[],
  );

  @override
  List<Widget> createButtonItems(){
    final List<Widget> items = entitiesWithStages.map<Widget>((EntityWithStage entity){
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