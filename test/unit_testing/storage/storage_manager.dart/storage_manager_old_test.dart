import 'dart:convert';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import 'recient_activity_storage_data.dart' as recientActivityStorageData;

final FlutterSecureStorage fss = MockFlutterSecureStorage();
final Map<BlocName, Bloc> blocs = BlocProvidersCreator.blocsAsMap;
final ReceivePort _initReceivePort = ReceivePort();
final ReceivePort _blocsUpdatedReceivePort = ReceivePort();

SendPort _childUpdateBlocsReceiverPort;
Isolate _testingIsolate;
bool recentChosenProyectLoaded = false;

main()async{
  //TestWidgetsFlutterBinding.ensureInitialized();
  //_initStorageConnector();
  //await _verifyRecentActivityProjectsBloc();
  //for(int i = 0; i < 2200; i++){

  //}

  //_childUpdateBlocsReceiverPort.send('');
  //recentChosenProyectLoaded = await _blocsUpdatedReceivePort.first;
  //_testingIsolate.kill();
}

void _initStorageConnector(){
  StorageConnectorSingleton.storageConnector.fss = fss;
  (fss as MockFlutterSecureStorage).storage = recientActivityStorageData.data;
}

Future<void> _verifyRecentActivityProjectsBloc()async{
  final Map<String, SendPort> mainPorts = {
    'init_send_port':_initReceivePort.sendPort,
    'blocs_updated_send_port':_blocsUpdatedReceivePort.sendPort
  };
  _testingIsolate = await Isolate.spawn(_testProjectsBloc, mainPorts);
  
  final Map<String, dynamic> childReceiverPorts = await _initReceivePort.first;
  _childUpdateBlocsReceiverPort = childReceiverPorts['blocs_update_send_port'];  
}

void _testProjectsBloc(Map<String, SendPort> mainPorts)async{
  final ReceivePort initialReceivePort = ReceivePort();
  final ReceivePort blocsUpdatedReceiverPort = ReceivePort();
  final SendPort mainInitSendPort = mainPorts['init_send_port'];
  final SendPort mainUpdatedBlocsSendPort = mainPorts['blocs_updated_send_port'];
  mainInitSendPort.send({
    'initial_send_port':initialReceivePort.sendPort,
    'blocs_update_send_port':blocsUpdatedReceiverPort.sendPort
  });

  bool blocsAreUpdated = false;
  final Map<BlocName, Bloc> blocsMap = BlocProvidersCreator.blocsAsMap;
  //StorageManager.addRecientActivityDataToBlocs(blocsMap);
  
  test('', ()async{
    final ProjectsBloc pb = blocsMap[BlocName.Projects];
    pb.listen((ProjectsState state) {
      expect(jsonEncode(state.chosenProject.toJson()), recientActivityStorageData.chosenProjectAsString, reason: 'El chosen project del bloc debería ser igual al fake');
      blocsAreUpdated = true;
    });
  });
  

  await for(Map<String, dynamic> message in blocsUpdatedReceiverPort){
    mainUpdatedBlocsSendPort.send(blocsAreUpdated);
  }

}