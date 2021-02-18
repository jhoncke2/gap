import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';

class FormsServicesManager{
  static Future<void> loadForms(FormulariosBloc bloc){
    //TODO: Iplementar services
    final List<Formulario> forms = fakeData.formularios;
    bloc.add(SetForms(forms: forms));
  }
}