import 'dart:convert';
import 'dart:io';

final File fileData = File('assets/testing/formularios_data.txt');

Future<List<Map<String, dynamic>>> getDataAsJson()async{
  final String stringData = await fileData.readAsString();
  final List<Map<String, dynamic>> jsonData = json.decode(stringData).cast<Map<String, dynamic>>();
  return jsonData;
}