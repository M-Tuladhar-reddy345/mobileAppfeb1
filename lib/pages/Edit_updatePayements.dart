// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
import 'package:flutter_complete_guide/pages/Order.dart';
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

class editUpdatePayements extends StatefulWidget {
  String message;

  DateTime dateTime = DateTime.now();
  DateTime dateTime2;
  editUpdatePayements(this.message);
  String recNo;
  var amt_controller = TextEditingController();
  var payRefNo_controller = TextEditingController();
  var remarks_controller = TextEditingController();
  var Waiver_controller = TextEditingController()..text = '0';
  String prevAmt;
  String prevWaiver;

  String recType;

  String custcode;
  @override
  State<editUpdatePayements> createState() => _editUpdatePayementsState();
}

class _editUpdatePayementsState extends State<editUpdatePayements> {
  Future getReceipts;
  Future getReceiptbyrecNo;
  submit() async {
    String remarks = widget.remarks_controller.text;
    if (widget.remarks_controller.text.contains('Upd thru app') != false) {
      remarks = ' Amt ' +
          widget.prevAmt +
          ' to ' +
          widget.amt_controller.text +
          ' Waiver ' +
          widget.prevWaiver +
          ' to ' +
          widget.Waiver_controller.text +
          ' Date ' +
          DateFormat("d-M-y").format(widget.dateTime) +
          ' to ' +
          DateFormat("d-M-y").format(widget.dateTime2) +
          '-Upd Thru app';
    } else {
      remarks = ' Amt ' +
          widget.prevAmt +
          ' to ' +
          widget.amt_controller.text +
          ' Waiver ' +
          widget.prevWaiver +
          ' to ' +
          widget.Waiver_controller.text +
          ' Date ' +
          DateFormat("d-M-y").format(widget.dateTime) +
          ' to ' +
          DateFormat("d-M-y").format(widget.dateTime2);
    }
    final body = {
      'RecieptNo': widget.recNo,
      'Date': DateFormat("y-M-d").format(widget.dateTime),
      'Rectype': widget.recType,
      'payRefNo': widget.payRefNo_controller.text,
      'RecAmt': widget.amt_controller.text,
      'Waiver': widget.Waiver_controller.text,
      'Remarks': remarks,
      'Custcode': widget.custcode,
      'entryUser': main.storage.getItem('salesName'),
    };
    print(body);
    final url = Uri.parse(main.url_start +
        'mobileApp/UpdateReciept/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(response.body) as Map;
        widget.message = data['message'].toString();
        print(widget.message);
        if (widget.message.toString().contains('sucessfully')) {
          print(widget.recNo);
          // widget.dropdownValue = '';
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    receipt.Receiptpage(widget.message, data['RecNo'])),
          );
        }
      });
    }
  }

  get_ReceiptbyrecNo(recNo) async {
    if (recNo != '') {
      final url = Uri.parse(main.url_start +
          'mobileApp/RecieptDetailsbyrecno/' +
          recNo +
          '/' +
          main.storage.getItem('branch'));
      final response = await http.get(url);
      //  print(response.statusCode);

      if (response.statusCode == 200) {
        //  print(response.body);
        var data = json.decode(response.body) as Map;
        print(data);
        setState(() {
          widget.dateTime2 = DateFormat('d/M/y').parse(data['RecieptDate']);
          widget.recType = data['RecType'];
          widget.custcode = data['custCode'];
          widget.prevAmt = data['RecAmt'].toString();
          widget.prevWaiver = data['Waiver'].toString();
          widget.amt_controller.value =
              TextEditingValue(text: data['RecAmt'].toString());
          widget.Waiver_controller.value =
              TextEditingValue(text: data['Waiver'].toString());
          widget.payRefNo_controller.value =
              TextEditingValue(text: data['payRefNo'].toString());
          widget.remarks_controller.value =
              TextEditingValue(text: data['Remarks'].toString());
        });

        return data;
      }
    } else {
      return null;
    }
  }

  get_Receipts(date) async {
    final url = Uri.parse(main.url_start +
        'mobileApp/Receipts/' +
        DateFormat("y-M-d").format(date).toString() +
        '/' +
        main.storage.getItem('salesName').toString() +
        '/'+
          main.storage.getItem('branch'));
    final response = await http.get(url);

    //  print(response.statusCode);

    if (response.statusCode == 200) {
      //  print(response.body);
      var data = json.decode(response.body) as Map;
      print(data);
      print(data['results'].length);
      return data['results'];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReceipts = get_Receipts(widget.dateTime);
    getReceiptbyrecNo = get_ReceiptbyrecNo(widget.recNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Edit Update Payments'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            message.Message(widget.message),
            Container(
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
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime.now())
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                widget.dateTime = value;
                                getReceipts = get_Receipts(widget.dateTime);
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
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: [
                    Text('RecNo: '),
                    FutureBuilder(
                      future: getReceipts,
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              width: 30,
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                            if (snapshot.data != null) {
                              return Container(
                                width: 210,
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: widget.recNo,

                                  // icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    width: 300,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      widget.recNo = newValue;
                                      getReceiptbyrecNo =
                                          get_ReceiptbyrecNo(widget.recNo);
                                    });
                                  },
                                  items: snapshot.data
                                      .map<DropdownMenuItem<String>>((v) {
                                    return DropdownMenuItem<String>(
                                        value: v['recNo'].toString(),
                                        child: Text(v['recNo'].toString() +
                                            '-' +
                                            v['custName'].toString()));
                                  }).toList(),
                                ),
                              );
                            } else {
                              return Text('Some error fetching pls try later');
                            }
                        }
                      },
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  // color: Theme.of(context).primaryColor,
                  width: 300,
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                        future: getReceiptbyrecNo,
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          //  print(snapshot.data);
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(child: Text('Chooose recNo'));
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.done:
                              if (snapshot.data == null) {
                                return Text('Chooose recNo...');
                              } else {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Reciept No: ' +
                                            snapshot.data['RecieptNo']
                                                .toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        'Amount: ' +
                                            snapshot.data['RecAmt'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                child: Text(
                                                  'Pick Date',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2001),
                                                          lastDate:
                                                              DateTime.now())
                                                      .then((value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        widget.dateTime2 =
                                                            value;
                                                      });
                                                    }
                                                  });
                                                }),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(DateFormat("d-M-y")
                                                .format(widget.dateTime)),
                                          )
                                        ],
                                      ),
                                      DropdownButton(
                                        isExpanded: true,
                                        value: widget.recType,

                                        // icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          width: 300,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            widget.recType = newValue;
                                            // widget.dropdownValue2.value = newValue;
                                          });
                                        },
                                        items: snapshot.data['Rectypes']
                                            .map<DropdownMenuItem<String>>((v) {
                                          return DropdownMenuItem<String>(
                                            value: v.toString(),
                                            child: Text(v.toString()),
                                          );
                                        }).toList(),
                                      ),
                                      TextFormField(
                                          controller: widget.amt_controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Rec Amt",
                                            hintText: "Rec Amt",
                                          )),
                                      TextFormField(
                                          controller: widget.Waiver_controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Waiver",
                                            hintText: "Waiver",
                                          )),
                                      TextFormField(
                                          controller:
                                              widget.payRefNo_controller,
                                          // keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Payment Reference No",
                                            hintText: "pay Ref No",
                                          )),
                                      TextFormField(
                                          controller: widget.remarks_controller,
                                          decoration: InputDecoration(
                                            labelText: "Remarks",
                                            hintText: "Remarks",
                                          )),
                                      FlatButton(
                                        color: Colors.purple,
                                        onPressed: () => submit(),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                              break;
                            case ConnectionState.active:
                              // TODO: Handle this case.
                              break;
                          }
                        }),
                  )),
            )
          ]),
        ));
  }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {

//   AnimationController _animationController;

//   @override
//   void initState() {
//      super.initState();
//     _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
//     _animationController.addListener((){
// 		  setState((){});
// 	  });
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//      super.dispose();
//     _animationController.dispose();
//   }
// }
