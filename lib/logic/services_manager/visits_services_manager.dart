import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class VisitsServicesManager{
  static Future<void> loadVisits(VisitsBloc bloc)async{
    //TODO: Iplementar services
    final List<OldVisit> visits = fakeData.visits;
    bloc.add(SetVisits(visits: visits));
    await VisitsStorageManager.setVisits(visits);
  }
}