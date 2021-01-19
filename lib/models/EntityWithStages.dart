import 'package:flutter/material.dart';
import 'package:gap/enums/process_stage.dart';

abstract class EntityWithStages{
  final ProcessStage currentStage;
  final String name;
  EntityWithStages({
    @required this.currentStage,
    @required this.name
  });
}