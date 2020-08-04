import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class My extends StatefulWidget {
  final String pdfUrl;
  My(this.pdfUrl);
  @override
  _MyState createState() => _MyState(pdfUrl);
}

class _MyState extends State<My> {
  String _version = 'Unknown';
  String pdfUrl;
  _MyState(this.pdfUrl);

  @override
  void initState() {
    super.initState();
    initPlatformState();

    PdftronFlutter.openDocument(pdfUrl + ".pdf");
  }

  Future<void> initPlatformState() async {
    String version;

    try {
      PdftronFlutter.initialize(
          "Insert commercial license key here after purchase");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PDF Viewer'),
        ),
        body: Center(
          child: Text('Running on: $_version\n'),
        ),
      ),
    );
  }
}
