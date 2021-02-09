part of 'entities.dart';

abstract class EntityWithStages{
  final ProcessStage stage;
  final String name;
  EntityWithStages({
    @required this.stage,
    @required this.name
  });

  Map<String, dynamic> toJson() => {
    'name':this.name,
    'stage': defineStage()
  };

  String defineStage(){
    if(this.stage == ProcessStage.Pendiente)
      return 'pendiente';
    else
      return 'realizada';
  }
}