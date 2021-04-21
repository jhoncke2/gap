import 'dart:io';

final File fileData = File('assets/testing/custom_form_fields_data.txt');

Future<String> getDataAsString()async{
  final String stringData = await fileData.readAsString();
  return stringData;
}