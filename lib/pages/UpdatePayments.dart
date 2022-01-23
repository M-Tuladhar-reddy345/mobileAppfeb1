import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
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

// import 'package:date_field/date_field.dart';

class UpdatePayments extends StatefulWidget {
  String message;
  final ValueNotifier<String> dropdownValue2 = ValueNotifier<String>('');
  String custCode;
  String dropdownValue;
  String recNo;
  var amt_controller = TextEditingController();
  var payRefNo_controller = TextEditingController();
  var remarks_controller = TextEditingController();
  var Waiver_controller = TextEditingController();
  String recType;
  DateTime dateTime = DateTime.now();

  UpdatePayments(this.message);

  @override
  State<UpdatePayments> createState() => _UpdatePaymentsState();
}

class _UpdatePaymentsState extends State<UpdatePayments> {
  submit() async {
    final body = {
      'RecieptNo': widget.recNo,
      'Date': DateFormat("y-M-d").format(widget.dateTime),
      'Rectype': widget.recType,
      'payRefNo': widget.payRefNo_controller.text,
      'RecAmt': widget.amt_controller.text,
      'Waiver': widget.Waiver_controller.text,
      'Remarks': widget.remarks_controller.text,
      'Custcode': widget.dropdownValue,
      'entryUser': main.storage.getItem('salesName'),
    };
    print(body);
    final url = Uri.parse(main.url_start +
        'mobileApp/CreateNewReciept/' +
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

  get_customers() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/CustomerDetails/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.get(url);

    //  print(response.statusCode);

    if (response.statusCode == 200) {
      //  print(response.body);
      var data = json.decode(response.body) as Map;
      //  print(data['results']);

      List Customers = data['results']
          .map<models.Customer>((json) => models.Customer.fromjson(json))
          .toList();

      return Customers;
    }
  }

  get_Reciept(custcode) async {
    if (custcode != '') {
      final url = Uri.parse(main.url_start +
          'mobileApp/RecieptDetails/' +
          custcode +
          '/' +
          main.storage.getItem('branch'));
      final response = await http.get(url);
      //  print(response.statusCode);

      if (response.statusCode == 200) {
        //  print(response.body);
        var data = json.decode(response.body) as Map;
        //  print(data['results']);
        //  print(data);
        setState(() {
          widget.recNo = data['RecieptNo'].toString();
        });
        return data;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Raithanna Dairy'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            navbar.Navbar(widget.message),
            Text(
              'Update Payments',
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            Column(children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: FutureBuilder(
                        future: get_customers(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Text('loading'),
                            );
                          } else
                            return Container(
                              child: DropdownButton(
                                isExpanded: true,
                                value: widget.dropdownValue,

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
                                    widget.dropdownValue = newValue;
                                    widget.dropdownValue2.value = newValue;
                                  });
                                },
                                items: snapshot.data
                                    .map<DropdownMenuItem<String>>((v) {
                                  return DropdownMenuItem<String>(
                                    value: v.custCode.toString(),
                                    child: Text(v.custName.toString() +
                                        '-' +
                                        v.custCode.toString() +
                                        '-' +
                                        v.Osamt.toString()),
                                  );
                                }).toList(),
                              ),
                            );
                        },
                      ),
                    ),
                    // FlatButton(
                    //     color: Theme.of(context).primaryColor,
                    //     onPressed: () {

                    //     },
                    //     child: Text(
                    //       'Fetch',
                    //       style: TextStyle(color: Colors.white),
                    //     ))
                  ]),
              Container(
                  // color: Theme.of(context).primaryColor,
                  width: 300,
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<String>(
                      builder:
                          (BuildContext context, String value, Widget child) {
                        //  print(value);
                        return SingleChildScrollView(
                          child: FutureBuilder(
                              future: get_Reciept(value),
                              builder: (context, snapshot) {
                                //  print(snapshot.data);
                                if (snapshot.data == null) {
                                  return Text('Chooose user...');
                                } else
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
                                              snapshot.data['RecAmt']
                                                  .toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                          widget.dateTime =
                                                              value;
                                                        });
                                                      }
                                                    });
                                                  }),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              .map<DropdownMenuItem<String>>(
                                                  (v) {
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
                                            controller:
                                                widget.Waiver_controller,
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
                                            controller:
                                                widget.remarks_controller,
                                            decoration: InputDecoration(
                                              labelText: "Remarks",
                                              hintText: "Remarks",
                                            )),
                                        FlatButton(
                                          color: Colors.purple,
                                          onPressed: () => submit(),
                                          child: Text(
                                            'Submit',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                              }),
                        );
                      },
                      valueListenable: widget.dropdownValue2,
                    ),
                  ))
            ])
          ]),
        ));
  }
}
