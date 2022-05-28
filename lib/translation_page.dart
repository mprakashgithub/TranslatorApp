import 'package:flutter/material.dart';
import 'package:flutter_translator/flutter_translator.dart';
import 'package:translator_app/app_locale.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TranslatorGenerator _translator = TranslatorGenerator.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translator.getString(context, AppLocale.title)),
      ),
      body: Center(
        child: Text(_translator.getString(context, AppLocale.name)),
      ),
    );
  }
}
