import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import '../widgets/message.dart' as message;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import '../main.dart' as main;

class ExtractdailyIndentpage extends StatefulWidget {
  String message;
  File xls;
  DateTime dateTime = DateTime.now();

  ExtractdailyIndentpage(this.message);

  @override
  State<ExtractdailyIndentpage> createState() => _ExtractdailyIndentpageState();
}

class _ExtractdailyIndentpageState extends State<ExtractdailyIndentpage> {
  bool isLoading = false;

  Future extractDailycsv() async{
    var date = DateFormat("y-M-d").format(widget.dateTime);
    var url =Uri.parse(main.url_start+ 'mobileApp/dailyindentExcelExtract/'+main.storage.getItem('branch').toString()+'/'+date.toString()+'/');
    setState(() {
      isLoading = true;
    });
    print(url);
    var request = http.MultipartRequest('POST', url);
  request.files.add(
    http.MultipartFile(
      'myFile',
      widget.xls.readAsBytes().asStream(),
      widget.xls.lengthSync(),
      filename: widget.xls.path.split("/").last
    )
  );
  var response = await request.send();
    if (response.statusCode == 200){
      setState(() {
        widget.message = 'success';
        isLoading = false;
      });
    }else if(response.statusCode == 104){
       setState(() {
        widget.message = 'wrong file extenstion';
        isLoading = false;
      });
    }else if(response.statusCode == 106){
       setState(() {
        widget.message = 'Naming convention not satisfied it should be in the format "RMDLyyyyMMdd000" 000 stands for code';
        isLoading = false;
      });
      
    }else if(response.statusCode == 108){
       setState(() {
        widget.message = 'Date in name is not same as date selected';
        isLoading = false;
      });

    }
    else if(response.statusCode == 110){
       setState(() {
        widget.message = 'aldready extracted with this file';
        isLoading = false;
      });

    }
    
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Extract daily Indent'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            message.Message(widget.message),
            ElevatedButton(onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles();
              if (result != null){
                setState(() {
                  widget.xls = File(result.files.single.path);                  
                });
              }

            },child: Text('Select File', style: TextStyle(fontSize: 18),)),
            Text('CSV File for extract is only accepted', style: TextStyle(fontSize: 15),),
            widget.xls != null ?
            Text(basename(widget.xls.path), style: TextStyle(fontSize: 18),):
            Text('', style: TextStyle(fontSize: 18),),
            Center(
              child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Pick Date',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day + 7))
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  widget.dateTime = value;
                                });
                              }
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat("d-M-y").format(widget.dateTime),
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],),
            ),
            ElevatedButton(onPressed: () =>extractDailycsv(),
            child: Text('Upload', style: TextStyle(fontSize: 18),)),
            isLoading == true ? CircularProgressIndicator() : Text('')
          ]),
        ));
  }
}

