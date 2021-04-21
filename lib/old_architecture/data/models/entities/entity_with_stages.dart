part of 'entities.dart';

abstract class EntityWithStageOld extends Entity{
  ProcessStage stage;
  final String name;
  EntityWithStageOld({
    @required this.stage,
    @required this.name,
    int id
  }):super(id:id);

  Map<String, dynamic> toJson() => {
    'id':this.id,
    'name':this.name,
    'stage': stage.value
  };

  String defineStage(){
    if(this.stage == ProcessStage.Pendiente)
      return 'pendiente';
    else
      return 'realizada';
  }
}