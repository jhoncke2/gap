import 'dart:convert';

import 'package:gap/clean_architecture_structure/core/data/data_sources/index/index_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/index_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{}

IndexLocalDataSourceImpl dataSource;
MockStorageConnector storageConnector;

String tStringIndex;
Map<String, dynamic> tJsonIndex;
IndexModel tIndex;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    dataSource = IndexLocalDataSourceImpl(
      storageConnector: storageConnector
    );

    tStringIndex = callFixture('index.json');
    tJsonIndex = jsonDecode(tStringIndex);
    tIndex = IndexModel.fromJson(tJsonIndex);
  });

  group('setStorageConnector', (){
    test('should set the index successfuly', ()async{
      await dataSource.setIndex(tIndex);
      verify(storageConnector.setMap(tJsonIndex, IndexLocalDataSourceImpl.indexStorageKey));
    });
  });

  group('getStorageConnector', (){
    test('should obtain the jsonIndex from the storageConnector', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tJsonIndex);
      await dataSource.getIndex();
      verify(storageConnector.getMap(IndexLocalDataSourceImpl.indexStorageKey));
    });

    test('should return the index', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tJsonIndex);
      final IndexModel index = await dataSource.getIndex();
      expect(index, tIndex);
    });
  });
}