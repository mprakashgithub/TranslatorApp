import 'dart:io';

import 'package:flutter/material.dart';
import 'package:translator_app/screens/hive_db.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

// Future<void> main() async {
//   Directory directory = await pathProvider.getApplicationDocumentsDirectory();
//   Hive.init(directory.path);

//   runApp(MyApp());
// }
void main() async {
// Initializes Hive with a valid directory in your app files
  await Hive.init;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HiveDB(),
    );
  }
}
