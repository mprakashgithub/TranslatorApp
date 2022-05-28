import 'package:flutter/material.dart';
import 'package:flutter_translator/flutter_translator.dart';
import 'package:translator_app/CircleAnimationBreathing.dart';
import 'package:translator_app/app_locale.dart';
import 'package:translator_app/circle_timer.dart';
import 'package:translator_app/g_translation.dart';
import 'package:translator_app/screens/excel_uploader.dart';
import 'package:translator_app/screens/webview.dart';
import 'package:translator_app/speech_to_text.dart';
import 'package:translator_app/translation_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TranslatorGenerator _translator = TranslatorGenerator.instance;

  @override
  void initState() {
    // _translator.init(
    //   supportedLanguageCodes: ['en', 'km', 'ja'],
    //   initLanguageCode: 'km',
    // );
    _translator.initWithMap(
      mapLocales: [
        MapLocale('en', AppLocale.EN),
        MapLocale('km', AppLocale.KM),
        MapLocale('ja', AppLocale.JA),
        MapLocale('hi', AppLocale.HI),
      ],
      initLanguageCode: 'en',
    );
    _translator.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: _translator.supportedLocales,
      localizationsDelegates: _translator.localizationsDelegates,
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TranslatorGenerator _translator = TranslatorGenerator.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translator.getString(context, AppLocale.title)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MyWebView(
                          title: "Webview inside app",
                          selectedUrl: "https://flutter.dev/",
                        )));
              },
              icon: const Icon(Icons.mic)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TranslationPage()));
              },
              icon: const Icon(Icons.waves))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_translator.getString(context, AppLocale.name)),
            Text('Current language is: ${_translator.getLanguageName()}'),
            const SizedBox(height: 64.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text('English'),
                    onPressed: () {
                      _translator.translate('en');
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Khmer'),
                    onPressed: () {
                      _translator.translate('km');
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Japanese'),
                    onPressed: () {
                      _translator.translate('ja', save: false);
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Hindi'),
                    onPressed: () {
                      _translator.translate('hi');
                    },
                  ),
                ),
              ],
            ),
            MaterialButton(
              color: Colors.deepPurple,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GTranslationPage()));
              },
              child: const Text("GTranslation"),
            ),
            MaterialButton(
              color: Colors.deepPurple.shade100,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CircleAnimation()));
              },
              child: const Text("Animated Circle"),
            ),
            MaterialButton(
              color: Colors.deepPurple.shade100,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CircleTimer()));
              },
              child: const Text("Timer"),
            )
          ],
        ),
      ),
    );
  }
}
