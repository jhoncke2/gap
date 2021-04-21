import 'dart:io';

String callFixture(String name) => File('test/clean_architecture_testing/fixtures/$name').readAsStringSync();