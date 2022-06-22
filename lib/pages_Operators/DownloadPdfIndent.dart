import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import '../widgets/Appbar.dart';
import '../widgets/navbar.dart' as navbar;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

import 'package:file_picker/file_picker.dart';

// ignore: must_be_immutable
class PdfIndentpage extends StatefulWidget {
  String message;

  PdfIndentpage();
  DateTime dateTimefrom = DateTime.now();
  DateTime dateTimeto = DateTime.now();
  DateTime dateTimeExExtract = DateTime.now();

  @override
  State<PdfIndentpage> createState() => _PdfIndentpages_Operatorstate();
}

class _PdfIndentpages_Operatorstate extends State<PdfIndentpage> {
  bool isLoading = false;

  var progress;

  Future<File> _storeFile(String url, List<int> bytes) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    String fileName = datefrom + 'to' + dateto + '.pdf';


    await Permission.storage.request();
    String dir = await FilePicker.platform.getDirectoryPath();
              
    final File file = File('${dir}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> fetchPDF(context) async {
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
    if (response.statusCode == 200) {
      setState(() {
        isLoading= false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('successfully Downloaded pdf'),backgroundColor: Colors.green,));
         
        
      });
      return _storeFile(response.body, response.bodyBytes);
    } else {
      return null;
    }
  }

  Future<File> _storeFileCSV(String filename, List<int> bytes) async {
    var datefrom = DateFormat("dd-MM-y").format(widget.dateTimefrom);
    var dateto = DateFormat("dd-MM-y").format(widget.dateTimeto);
    String fileName = 'Indent'+datefrom+'to'+dateto+'.xls';


    await Permission.storage.request();
    String dir = await FilePicker.platform.getDirectoryPath();
              
    final File file = File('${dir}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> fetchCSV(context) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    if ((widget.dateTimeto.day - widget.dateTimefrom.day) <= 16){
    var brch = main.storage.getItem('branch');
    
    final response = await http.get(Uri.parse(main.url_start +
        'dailyindentCSV/' +
        datefrom.toString() +
        '/' +
        dateto.toString() +
        '/' +
        brch.toString()));
    if (response.statusCode == 200) {
      setState(() {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('successfully Downloaded XLS'),backgroundColor: Colors.green,));
        isLoading =false;
      });
      return _storeFileCSV(response.body, response.bodyBytes);
    } else {
      return null;
    }
    }else{
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('selected days cannot exceed 16 days'),backgroundColor: Colors.red,));
        isLoading = false;
      });
      return null;
    }
  }
  Future<File> _storeFileExtractionCSV(String filename, List<int> bytes) async {
    var datefrom = DateFormat("dd-MM-y").format(widget.dateTimefrom);
    var dateto = DateFormat("dd-MM-y").format(widget.dateTimeto);

    Directory dr = Directory('/storage/emulated/0/Download');

    await Permission.storage.request();
    String dir = await FilePicker.platform.getDirectoryPath();
              
    final File file = File('${dir}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> fetchCSVExtraction(context) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimeExExtract);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeExExtract);
    var brch = main.storage.getItem('branch');

    final response = await http.get(Uri.parse(main.url_start +
        'mobileApp/dailyindentExtractCSV/' +
        datefrom.toString() +
        '/' +
        dateto.toString() +
        '/' +
        brch.toString()));
    print(main.url_start +
        'mobileApp/dailyindentExtractCSV/' +
        datefrom.toString() +
        '/' +
        dateto.toString() +
        '/' +
        brch.toString());
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('successfully Downloaded Extract XLS'),backgroundColor: Colors.green,));

      });
      return _storeFileExtractionCSV('RMDL'+DateFormat('yMMdd').format(DateTime.now())+'.xls', response.bodyBytes);
    } else {
      return null;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (main.storage.getItem('module_accessed').toString().contains('Downloadpdfindent')==false){main.storage.setItem('module_accessed', main.storage.getItem('module_accessed').toString()+' Downloadpdfindent');}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBarCustom('Download PDF Indent', Size(MediaQuery.of(context).size.width,56)),
        body: SingleChildScrollView(
          child: Column(children: [
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
                  final File pdf = await fetchPDF(context);
                  OpenFile.open(pdf.path);
                  // print(pdf);
                  // openPDF(context, pdf);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Download PDF',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final File XLS = await fetchCSV(context);
                  OpenFile.open(XLS.path);
                  // print(pdf);
                  // openPDF(context, pdf);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Download XLS',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            Container(
              color: Theme.of(context).primaryColorLight,
              child: Column(
                children: [
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
                              widget.dateTimeExExtract = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimeExExtract),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              final File XLS = await fetchCSVExtraction(context);
                              OpenFile.open(XLS.path);
                              // print(pdf);
                              // openPDF(context, pdf);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text('Download Extract XLS',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                        Text('Only one day accepted', style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isLoading == true ? CircularProgressIndicator() : Text('')
          ]),
        ));
  }
}
