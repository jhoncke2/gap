import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{
  
}

FormulariosLocalDataSourceImpl formulariosLocalDataSource;
MockStorageConnector storageConnector;

String tStringFormularios;
List<Map<String, dynamic>> tJsonFormularios;
List<FormularioModel> tFormularios;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    formulariosLocalDataSource = FormulariosLocalDataSourceImpl(storageConnector: storageConnector);

    tStringFormularios = callFixture('formularios.json');
    tJsonFormularios = jsonDecode(tStringFormularios).cast<Map<String, dynamic>>();
    tFormularios = formulariosFromJson(tJsonFormularios);
  });

  group('setFormularios', (){
    final int chosenVisitId = 1;
    test('should set the formularios succesfuly', ()async{
      await formulariosLocalDataSource.setFormularios(tFormularios, chosenVisitId);
      verify(storageConnector.setList(tJsonFormularios, '${FormulariosLocalDataSourceImpl.FORMULARIOS_STORAGE_KEY}_$chosenVisitId'));
    });
  });
  
  group('getFormularios', (){
    final int chosenVisitId = 1;
    test('should get the formularios successfuly', ()async{
      when(storageConnector.getList(any)).thenAnswer((_) async => tJsonFormularios);
      final List<FormularioModel> formularios = await formulariosLocalDataSource.getFormularios(chosenVisitId);
      verify(storageConnector.getList('${FormulariosLocalDataSourceImpl.FORMULARIOS_STORAGE_KEY}_$chosenVisitId'));
      expect(formularios, tFormularios);
    });
  });

  group('setChosenFormulario', (){
    int tChosenVisitId;
    FormularioModel tChosenFormulario;
    setUp((){
      tChosenVisitId = 1;
      tChosenFormulario = FormularioModel.fromJson(tFormularios[0].toJson());
      tChosenFormulario.completo = !tChosenFormulario.completo;
    });

    test('should set the chosen formulario successfuly', ()async{
      final List<FormularioModel> tUpdatedFormularios = List.of(tFormularios);
      tUpdatedFormularios[0] = tChosenFormulario;
      when(storageConnector.getList(any)).thenAnswer((_) async => tJsonFormularios);
      await formulariosLocalDataSource.setChosenFormulario(tChosenFormulario, tChosenVisitId);
      verify(storageConnector.setString('${tChosenFormulario.id}', '${FormulariosLocalDataSourceImpl.CHOSEN_FORMULARIO_STORAGE_KEY}'));
      verify(storageConnector.getList('${FormulariosLocalDataSourceImpl.FORMULARIOS_STORAGE_KEY}_$tChosenVisitId'));
      verify(storageConnector.setList(formulariosToJson(tUpdatedFormularios), '${FormulariosLocalDataSourceImpl.FORMULARIOS_STORAGE_KEY}_$tChosenVisitId'));
    });
  });

  group('getChosenFormulario', (){
    final int tChosenVisitId = 1;
    FormularioModel tChosenFormulario;
    setUp((){
      tChosenFormulario = tFormularios[0];
    });

    test('should get the chosen formulario successfuly', ()async{
      when(storageConnector.getString(any)).thenAnswer((_) async => '${tChosenFormulario.id}');
      when(storageConnector.getList(any)).thenAnswer((_) async => tJsonFormularios);
      final FormularioModel chosenFormulario = await formulariosLocalDataSource.getChosenFormulario(tChosenVisitId);
      verify(storageConnector.getString(FormulariosLocalDataSourceImpl.CHOSEN_FORMULARIO_STORAGE_KEY));
      verify(storageConnector.getList('${FormulariosLocalDataSourceImpl.FORMULARIOS_STORAGE_KEY}_$tChosenVisitId'));
      expect(chosenFormulario, equals(tChosenFormulario));
    });
  });

  group('deleteAll', (){
    test('should delete all successfuly', ()async{
      await formulariosLocalDataSource.deleteAll();
      verify(storageConnector.remove(FormulariosLocalDataSourceImpl.CHOSEN_FORMULARIO_STORAGE_KEY));
      verify(storageConnector.remove(FormulariosLocalDataSourceImpl.FORMULARIOS_STORAGE_KEY));
    });
  });
}

