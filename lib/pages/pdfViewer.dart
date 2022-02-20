import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import '../widgets/message.dart' as message;
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  String message;
  File pdf;

  PDFViewerPage(this.message, this.pdf);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('pdf'),
        ),
        body: SfPdfViewer.memory(
          widget.pdf.readAsBytesSync(),
          canShowPaginationDialog: true,
          canShowPasswordDialog: true,
          canShowScrollStatus: true,
          canShowScrollHead: true,
        ));
  }
}
