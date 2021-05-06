import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/entity_with_stage.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/button_with_stage_color.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/navigation_list.dart';
// ignore: must_be_immutable
class NavigationListWithStageColorButtons extends StatelessWidget {
  final List<EntityWithStage> entitiesWithStages;
  final Function(EntityWithStage entity) itemsFunction;
  final String Function(EntityWithStage entity) getItemButtonText;
  BuildContext context;
  NavigationListWithStageColorButtons({
    @required this.entitiesWithStages,
    @required this.itemsFunction,
    this.getItemButtonText
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return NavigationList(
      itemsLength: entitiesWithStages.length,
      createSingleNavButton: _createSingleNavButton
    );
  }

  Widget _createSingleNavButton(int index){
    EntityWithStage entity = entitiesWithStages[index];
    final String buttonText = (getItemButtonText==null)? entity.name : getItemButtonText(entity);
    return ButtonWithStageColor(
      name: buttonText,
      textColor: Theme.of(context).primaryColor,
      stage: entity.stage,
      onTap: (){itemsFunction(entity);}, 
    );
  }
}