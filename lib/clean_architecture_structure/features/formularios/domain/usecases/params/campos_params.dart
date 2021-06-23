import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';

class CamposParams extends Equatable{
  final List<CustomFormFieldOld> campos;
  CamposParams({
    @required this.campos
  });
  @override
  List<Object> get props => [this.campos];
}