import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';

class VisitsServicesManager{
  static Future<void> loadVisits(VisitsBloc bloc){
    //TODO: Iplementar services
    final List<Visit> visits = fakeData.visits;
    bloc.add(SetVisits(visits: visits));
  }
}