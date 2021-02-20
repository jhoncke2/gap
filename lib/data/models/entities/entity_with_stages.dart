part of 'entities.dart';

abstract class EntityWithStage extends Entity{
  final ProcessStage stage;
  final String name;
  EntityWithStage({
    @required this.stage,
    @required this.name,
    int id
  }):super(id:id);

  Map<String, dynamic> toJson() => {
    'id':this.id,
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