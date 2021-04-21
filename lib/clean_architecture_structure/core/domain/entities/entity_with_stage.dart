import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

// ignore: must_be_immutable
abstract class EntityWithStage extends Equatable{
  ProcessStage stage;
  String name;

  EntityWithStage({
    @required this.stage, 
    @required this.name
  });
}