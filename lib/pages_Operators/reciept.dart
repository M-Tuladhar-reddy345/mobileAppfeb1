import 'package:flutter/material.dart';
import '../widgets/navbar.dart' as navbar;
import '../main.dart' as main;
import 'dart:convert';


import 'package:http/http.dart' as http;

class Receiptpage extends StatefulWidget {
  String receiptNo;

  Receiptpage(this.receiptNo);

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
    return    Scaffold(       
        drawer: navbar.Navbar(),
        appBar: AppBar(
          actions: [Image(image: AssetImage("assets/images/RaithannaOLogo.png"),
                            height: 100,
                            width: 100,
                    // color: Color(0xFF3A5A98),
               ),],
          title: Text('Reciept'),
        ),
        body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(children: [
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
                            "\n" + snapshot.data['Remarks'].toString() + '  \n',
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