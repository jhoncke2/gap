import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';
import 'package:gap/old_architecture/logic/storage_managers/central_storage_manager/ids_storage_manager.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import 'testing_data.dart';

MockFlutterSecureStorage fss = MockFlutterSecureStorage();

/*
void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  //StorageConnectorSingleton.storageConnector.fss = fss;
  _testAddProjectId();
}
*/

void _testAddProjectId(){
  test('se testea la agregación de un project id', ()async{
    final String firstProjectId = jsonProjectsIds.entries.toList()[0].key;
    await IdsStorageManager.addProjectId(int.parse(firstProjectId));
    final Map<String, dynamic> projectInStorage = getStorageIdsData()[firstProjectId];
    expect(projectInStorage, isNotNull);
  });
}

Map<String, dynamic> getStorageIdsData(){
  return jsonDecode( fss.storage[IdsStorageManager.idsDataKey] ).cast<String, dynamic>();
}