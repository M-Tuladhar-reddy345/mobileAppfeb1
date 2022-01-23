import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import '../main.dart' as main;
import 'dart:convert';

import 'package:http/http.dart' as http;

class Receiptpage extends StatefulWidget {
  String message;
  String receiptNo;

  Receiptpage(this.message, this.receiptNo);

  @override
  State<Receiptpage> createState() => _ReceiptpageState();
}

class _ReceiptpageState extends State<Receiptpage> {
  get_Reciept(recNo) async {
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
        //  print(data['results']);
        //  print(data);
        // setState(() {
        //   widget.recNo = data['RecieptNo'].toString();
        // });
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
          // scrollDirection: Axis.horizontal,
          child: Column(children: [
            navbar.Navbar(widget.message),
            Text(
              'Reciept',
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
            FutureBuilder(
                future: get_Reciept(widget.receiptNo),
                builder: (context, snapshot) {
                  //  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Text('Chooose user...');
                  } else
                    return SingleChildScrollView(
                      child: Row(children: [
                        Column(
                          children: [
                            Text(
                              'Reciept No ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Reciept date ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Customer',
                              style: TextStyle(fontSize: 20),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(
                              'RecType ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Amount ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Remarks ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              ':',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              ': ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              ': ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(
                              ': ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              ': ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              ': ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              snapshot.data['RecieptNo'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              snapshot.data['RecieptDate'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '',
                              style: TextStyle(fontSize: 20),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                snapshot.data['custName'].toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(
                              snapshot.data['RecType'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              snapshot.data['RecAmt'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              snapshot.data['Remarks'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ]),
                    );
                })
          ]),
        ));
  }
}

// class ReceiptScreen extends StatefulWidget {
//   @override
//   _ReceiptScreenState createState() => _ReceiptScreenState();
// }

// class _ReceiptScreenState extends State<ReceiptScreen>
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