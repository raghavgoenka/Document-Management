// import 'package:flutter/material.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

// class PdfView extends StatefulWidget {
//   final String pdfUrl;
//   PdfView(this.pdfUrl);
//   @override
//   _PdfViewState createState() => _PdfViewState(pdfUrl);
// }

// class _PdfViewState extends State<PdfView> {
//   String pdfUrl;
//   _PdfViewState(this.pdfUrl);

//   PDFDocument _doc;

//   @override
//   void initState() {
//     super.initState();
//     _initPDF();
//   }

//   _initPDF() async {
//     final doc = await PDFDocument.fromURL(pdfUrl);
//     setState(() {
//       _doc = doc;
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your PDf"),
//       ),
//       body: PDFViewer(
//         document: _doc,
//       ),
//     );
//   }
// }
