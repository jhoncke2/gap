import 'dart:convert';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';

final Map<String, String> data = {
  'chosen_project':chosenProjectAsString,
  'visits': visitsAsString,
  'chosen_visit':chosenVisitAsString,
  'formularios': formsAsString,
  'chosen_form':chosenFormAsString,
  'commented_images':commentedImagesAsString
};
final String chosenProjectAsString = jsonEncode(fakeData.oldProjects[0].toJson());
final String visitsAsString = jsonEncode(  visitsToJson(fakeData.visits) );
final String chosenVisitAsString = jsonEncode(fakeData.visits[0].toJson());
final String formsAsString = jsonEncode(formulariosToJson(fakeData.formularios));
final String chosenFormAsString = jsonEncode(fakeData.formularios[0].toJson());
final String commentedImagesAsString = jsonEncode(commentedImagesToJson(fakeData.commentedImages));
//2021-02-10T16:30:14.944275