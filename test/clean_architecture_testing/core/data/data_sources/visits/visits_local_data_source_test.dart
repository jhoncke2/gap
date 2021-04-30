import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{

}

VisitsLocalDataSourceImpl visitsLocalDataSource;
MockStorageConnector storageConnector;

String tStringVisits;
List<Map<String, dynamic>> tJsonVisits;
List<VisitModel> tVisits;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    visitsLocalDataSource = VisitsLocalDataSourceImpl(storageConnector: storageConnector);

    tStringVisits = callFixture('visits.json');
    tJsonVisits = jsonDecode(tStringVisits).cast<Map<String, dynamic>>();
    tVisits = visitsFromRemoteJson(tJsonVisits);
  });

  group('setVisits', (){
    final int tProjectId = 1;
    test('should set visits successfuly', ()async{
      await visitsLocalDataSource.setVisits(tVisits, tProjectId);
      verify(storageConnector.setList(tJsonVisits, '${VisitsLocalDataSourceImpl.BASE_VISITS_STORAGE_KEY}_$tProjectId'));
    });
  });

  group('getVisits', (){
    final int tProjectId = 1;
    test('should set visits successfuly', ()async{
      when(storageConnector.getList(any)).thenAnswer((_)async => tJsonVisits);
      final List<VisitModel> visits = await visitsLocalDataSource.getVisits(tProjectId);
      verify(storageConnector.getList('${VisitsLocalDataSourceImpl.BASE_VISITS_STORAGE_KEY}_$tProjectId'));
      expect(visits, equals(tVisits));
    });
  });

  group('setChosenVisit', (){
    int tChosenVisitId;
    VisitModel tChosenVisit;

    setUp((){
      tChosenVisitId = tVisits[0].id;
      tChosenVisit = tVisits[0];
    });

    test('should get the chosen visit successfuly', ()async{
      await visitsLocalDataSource.setChosenVisit(tChosenVisit);
      verify(storageConnector.setString('$tChosenVisitId', VisitsLocalDataSourceImpl.CHOSEN_VISIT_STORAGE_KEY));
    });
  });

  group('getChosenVisit', (){
    final int tChosenProjectId = 1;
    int tChosenVisitId;
    VisitModel tChosenVisit;

    setUp((){
      tChosenVisitId = tVisits[0].id;
      tChosenVisit = tVisits[0];
    });

    test('should get the chosen visit successfuly', ()async{
      when(storageConnector.getString(any)).thenAnswer((realInvocation)async => '$tChosenVisitId');
      when(storageConnector.getList(any)).thenAnswer((realInvocation)async => tJsonVisits);

      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(tChosenProjectId);

      verify(storageConnector.getString(VisitsLocalDataSourceImpl.CHOSEN_VISIT_STORAGE_KEY));
      verify(storageConnector.getList('${VisitsLocalDataSourceImpl.BASE_VISITS_STORAGE_KEY}_$tChosenProjectId'));
      expect(chosenVisit, equals(tChosenVisit));
    });
  });

  group('deleteAll', (){
    test('should delete all successfuly', ()async{
      await visitsLocalDataSource.deleteAll();
      verify(storageConnector.remove(VisitsLocalDataSourceImpl.CHOSEN_VISIT_STORAGE_KEY));
      verify(storageConnector.remove(VisitsLocalDataSourceImpl.BASE_VISITS_STORAGE_KEY));
    });
  });
}