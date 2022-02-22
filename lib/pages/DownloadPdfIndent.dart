import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
import 'package:flutter_complete_guide/pages/pdfViewer.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import '/api.dart' as api;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'reciept.dart' as receipt;
import '../widgets/message.dart' as message;
import 'package:async/async.dart' as asyncc;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

// ignore: must_be_immutable
class PdfIndentpage extends StatefulWidget {
  String message;

  PdfIndentpage(this.message);
  DateTime dateTimefrom = DateTime.now();
  DateTime dateTimeto = DateTime.now();

  @override
  State<PdfIndentpage> createState() => _PdfIndentpageState();
}

class _PdfIndentpageState extends State<PdfIndentpage> {
  bool isLoading = false;

  var progress;

  Future<File> _storeFile(String url, List<int> bytes) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    String fileName = datefrom + 'to' + dateto + '.pdf';

    Directory dir = Directory('/storage/emulated/0/Download');

    print(dir);
    await Permission.storage.request();

    final File file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> fetchPDF() async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    var brch = main.storage.getItem('branch');

    final response = await http.get(Uri.parse(main.url_start +
        'dailyindentPDF/' +
        datefrom.toString() +
        '/' +
        dateto.toString() +
        '/' +
        brch.toString()));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return _storeFile(response.body, response.bodyBytes);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('PdfIndent'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            message.Message(widget.message),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              widget.dateTimefrom = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimefrom),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            Text(
              'To',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              widget.dateTimeto = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimeto),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final File pdf = await fetchPDF();
                  // print(pdf);
                  openPDF(context, pdf);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Download PDF',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            isLoading == true ? CircularProgressIndicator() : Text('')
          ]),
        ));
  }

  openPDF(BuildContext context, File pdf) {
    // print(pdf.path);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PDFViewerPage('', pdf)));
  }
}
