import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';

abstract class VisitsRemoteDataSource{
  Future<List<VisitModel>> getVisits(int projectId, String accessToken);
}