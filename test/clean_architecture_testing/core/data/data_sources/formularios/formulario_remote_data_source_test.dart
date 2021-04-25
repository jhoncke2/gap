import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client{}

FormulariosRemoteDataSourceImpl remoteDataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    remoteDataSource = FormulariosRemoteDataSourceImpl(
      client: client
    );
  });

  group('getFormularios', (){

  });
}