import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class VisitsRepository{
  Future<Either<Failure, List<Visit>>> getVisits(int projectId);
  Future<Either<Failure, void>> setChosenVisit(Visit visit);
  Future<Either<Failure, Visit>> getChosenVisit(int projectId);
}