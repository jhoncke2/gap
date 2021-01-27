
import 'package:gap/logic/enums/process_stage.dart';
import 'package:gap/logic/models/entities/EntityWithStages.dart';

class Visit extends EntityWithStages{
  final DateTime date;

  Visit.fromJson(Map<String, dynamic> json)
    :
    this.date = DateTime.parse(json['fecha']),
    super(
      currentStage: (json['step']=='pendiente')? ProcessStage.Pendiente : ProcessStage.Realizada,
      name: json['name']
    )
    ;
}