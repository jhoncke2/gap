import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';

class FormsServicesManager{
  static Future<List<OldFormulario>> loadForms(FormulariosBloc bloc, int visitId)async{
    //TODO: Iplementar services
    final List<OldFormulario> forms = fakeData.formularios;
    bloc.add(SetForms(forms: forms));
    await FormulariosStorageManager.setForms(forms);
    return forms;
  }
}