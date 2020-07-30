import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextTranslation extends StatefulWidget {
  @override
  _TextState createState() => _TextState();
}

class _TextState extends State<TextTranslation> {
  FlutterTts flutterTts = FlutterTts();

  String hindi;
  String p;
  int index;
  void translation(p) {
    print(p);
    print(languageCode[index]);
    GoogleTranslator translator = GoogleTranslator();

    translator.translate(p, to: languageCode[index]).then((output) {
      setState(() {
        hindi = output;
        print(hindi);
      });
    });
  }

  Future textToSpeech(words) async {
    print("111111111111111111");

    print(await flutterTts.getLanguages);
    await flutterTts.setLanguage("kn-IN");
    await flutterTts.speak(hindi);
  }

  List<String> language = [
    "",
    "Estonian",
    "Russian",
    "Spanish",
    "French",
    "Hindi",
    "Gujarati",
    "Kannada"
  ];
  List<String> languageCode = ["", "et", "ru", "es", "fr", "hi", "gu", "kn"];
  List<String> voiceCode = [
    "ko-KR",
    "ru-RU",
    "zh-TW",
    "hu-HU",
    "th-TH",
    "nb-NO",
    "da-DK",
    "tr-TR",
    "et-EE",
    "bs",
    "sw",
    "pt-PT",
    "vi-VN",
    "en-US",
    "sv-SE",
    "su-ID",
    "bn-BD",
    "el-GR",
    "hi-IN",
    "fi-FI",
    "km-KH",
    "bn-IN",
    "fr-FR",
    "uk-UA",
    "en-AU",
    "nl-NL",
    "fr-CA",
    "sr",
    "pt-BR",
    "si-LK",
    "de-DE",
    "ku",
    "cs-CZ",
    "pl-PL",
    "sk-SK",
    "fil-PH",
    "it-IT",
    "ne-NP",
    "hr",
    "en-NG",
    "zh-CN",
    "es-ES",
    "cy",
    "ja-JP",
    "sq",
    "yue-HK",
    "en-IN",
    "es-US",
    "jv-ID",
    "la",
    "id-ID",
    "ro-RO",
    "ca",
    "ta",
    "en-GB"
  ];
  String toLanguage = "";

  String text;
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Text Translator"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: x,
            padding: EdgeInsets.fromLTRB(x * 0.03, x * 0.1, x * 0.03, 0.0),
            child: CupertinoTextField(
              placeholder: "Enter text to be translated",
              textAlign: TextAlign.justify,
              maxLines: 8,
              style: TextStyle(
                fontFamily: 'fonty',
                color: Colors.black,
                fontSize: 20.0,
              ),
              padding: EdgeInsets.all(10.0),
              onChanged: (changedText) {
                setState(() {
                  p = changedText;
                  if (p != null) {}
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            width: MediaQuery.of(context).size.width * 0.53,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.white),
            child: FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration.collapsed(
                    hintText: "Select",
                  ),
                  isEmpty: toLanguage == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: toLanguage,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          toLanguage = newValue;
                          index = language.indexOf(newValue);
                          print(language.indexOf(newValue));
                          translation(p);
                        });
                      },
                      items: language.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: x,
            padding: EdgeInsets.fromLTRB(x * 0.03, x * 0.1, x * 0.03, 0.0),
            child: CupertinoTextField(
              placeholder: hindi,
              textAlign: TextAlign.justify,
              maxLines: 8,
              style: TextStyle(
                fontFamily: 'fonty',
                color: Colors.black,
                fontSize: 20.0,
              ),
              padding: EdgeInsets.all(10.0),
              onTap: () {
                textToSpeech(hindi);
              },
            ),
          ),
        ],
      ),
    );
  }
}
