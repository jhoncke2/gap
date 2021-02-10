import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_managers/storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/mock_flutter_secure_storage.dart';
import './storage_manager_descriptions.dart' as descriptions;
import './recient_activity_storage_data.dart' as recientActivityStorageData;

final FlutterSecureStorage fss = MockFlutterSecureStorage();
final Map<BlocName, Bloc> blocs = BlocProvidersCreator.blocsAsMap;

main(){
  _initStorageConnector();
  _testAddCurrentActivityDataToBlocs();
}

void _initStorageConnector(){
  StorageConnectorSingleton.storageConnector.fss = fss;
  (fss as MockFlutterSecureStorage).storage = recientActivityStorageData.data;
}

void _testAddCurrentActivityDataToBlocs(){
  test(descriptions.testAddRecientActivityDataToBlocsDescription, (){
      _tryTestAddCurrentActivityDataToBlocs();
  });
}

Future<void> _tryTestAddCurrentActivityDataToBlocs()async{
  StorageManager.addRecientActivityDataToBlocs(blocs);
}

void _testAddPreloadedDataToBlocs(){
  test(descriptions.testAddPreloadedDataToBlocsDescription, (){
    _tryTestAddPreloadedDataToBlocs();    
  });  
}

Future<void> _tryTestAddPreloadedDataToBlocs()async{

}