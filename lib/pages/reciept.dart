import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import '../main.dart' as main;
import 'dart:convert';
import '../widgets/message.dart' as message;

import 'package:http/http.dart' as http;

class Receiptpage extends StatefulWidget {
  String message;
  String receiptNo;

  Receiptpage(this.message, this.receiptNo);

  @override
  State<Receiptpage> createState() => _ReceiptpageState();
}

class _ReceiptpageState extends State<Receiptpage> {
  Future getReceipt;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getReceipt = get_Reciept(widget.receiptNo);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.receiptNo);
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Reciept'),
        ),
        body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(children: [
            message.Message(widget.message),
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
                future: getReceipt,
                builder: (context, snapshot) {
                  //  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Text('Chooose user...');
                  } else
                    return Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Wrap(children: [
                          Text(
                            'CustName:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.data['custName'].toString() + '  \n'),
                          Text(
                            'RecieptNo:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.data['RecieptNo'].toString() + '  \n'),
                          Text(
                            'RecieptDate:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              snapshot.data['RecieptDate'].toString() + '  \n'),
                          Text(
                            'RecType:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.data['RecType'].toString() + '  \n'),
                          Text(
                            'RecAmt:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.data['RecAmt'].toString() + '  \n'),
                          Text(
                            '\nRemarks:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data['Remarks'].toString() + '  \n',
                          )
                          // snapshot.data['Remarks'].toString(),
                        ]));
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