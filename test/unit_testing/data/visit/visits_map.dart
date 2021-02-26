import 'dart:convert';
import 'dart:io';

final File fileData = File('assets/testing/visits_data.txt');

Future<Map<String, dynamic>> getDataAsJson()async{
  final String stringData = await fileData.readAsString();
  final Map<String, dynamic> jsonData = json.decode(stringData);
  return jsonData;
}