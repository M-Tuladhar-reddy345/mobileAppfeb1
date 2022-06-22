// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
import '../widgets/Appbar.dart';
import '../widgets/navbar.dart' as navbar;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reciept.dart' as receipt;

import 'package:async/async.dart' as asyncc;
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
  var Waiver_controller = TextEditingController()..text = '0';

  String recType;
  DateTime dateTime = DateTime.now();

  UpdatePayments();

  @override
  State<UpdatePayments> createState() => _UpdatePaymentsState();
}

class _UpdatePaymentsState extends State<UpdatePayments>
    with WidgetsBindingObserver {
  Future getCustomer;
  var getReciept;
  asyncc.AsyncMemoizer memoizer;

  submit() async {
    final body = {
      'RecieptNo': widget.recNo,
      'Date': DateFormat("y-M-d").format(widget.dateTime),
      'Rectype': widget.recType,
      'payRefNo': widget.payRefNo_controller.text,
      'RecAmt': widget.amt_controller.text,
      'Waiver': widget.Waiver_controller.text,
      'Remarks': widget.remarks_controller.text.toString() + '-Upd Thru App',
      'Custcode': widget.dropdownValue,
      'entryUser': main.storage.getItem('username'),
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
        
        if ( data['message'].toString().contains('sucessfully')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString()),backgroundColor: Colors.green,));
          print(widget.recNo);
          // widget.dropdownValue = '';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    receipt.Receiptpage(data['RecNo'])),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString()),backgroundColor: Colors.red,));
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

  Future get_Reciept(custcode) async {
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
          // widget.Waiver_controller.text = '0';
        });
        return data;
      }
    } else {
      return null;
    }
    // return this.memoizer.runOnce(() async {
    //   if (custcode != '') {
    //     final url = Uri.parse(main.url_start +
    //         'mobileApp/RecieptDetails/' +
    //         custcode +
    //         '/' +
    //         main.storage.getItem('branch'));
    //     final response = await http.get(url);
    //     //  print(response.statusCode);

    //     if (response.statusCode == 200) {
    //       //  print(response.body);
    //       var data = json.decode(response.body) as Map;
    //       //  print(data['results']);
    //       //  print(data);
    //       setState(() {
    //         widget.recNo = data['RecieptNo'].toString();
    //         // widget.Waiver_controller.text = '0';
    //       });
    //       return data;
    //     }
    //   } else {
    //     return null;
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getCustomer = get_customers();
    getReciept = get_Reciept('');
    if (main.storage.getItem('module_accessed').toString().contains('UpdatePayments')==false){main.storage.setItem('module_accessed', main.storage.getItem('module_accessed').toString()+' UpdatePayments');}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      print('ditached');
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
    } else if (state == AppLifecycleState.paused) {
      print('paused');
    } else if (state == AppLifecycleState.resumed) {
      print('resumed');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(       
        drawer: navbar.Navbar(),
        appBar: AppBarCustom('Update Payments', Size(MediaQuery.of(context).size.width,56)),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(children: [
              
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
                        child: FutureBuilder(
                          future: getCustomer,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.done:
                                return Container(
                                  width: 300,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: widget.dropdownValue,

                                    // icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.red),
                                    underline: Container(
                                      height: 2,
                                      width: 300,
                                      color: Colors.redAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        widget.dropdownValue = newValue;
                                        widget.dropdownValue2.value = newValue;
                                        getReciept = get_Reciept(newValue);
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
                                              v.Osamt.toString()));
                                    }).toList(),
                                  ),
                                );
                                break;
                              case ConnectionState.none:
                                // TODO: Handle this case.
                                break;
                              case ConnectionState.active:
                                // TODO: Handle this case.
                                break;
                            }
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
                      child: FutureBuilder(
                          future: getReciept,
                          builder: (context, snapshot) {
                            //  print(snapshot.data);
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Center(child: Text('Chooose user...'));
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.done:
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
                                              color: Colors.red),
                                          underline: Container(
                                            height: 2,
                                            width: 300,
                                            color: Colors.redAccent,
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
                                          color: Colors.blue,
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
                                break;
                              case ConnectionState.active:
                                // TODO: Handle this case.
                                break;
                            }
                          }),
                    ))
              ])
            ]),
          ),
        ));
  }
}
