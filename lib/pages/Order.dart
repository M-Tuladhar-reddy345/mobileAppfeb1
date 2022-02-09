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
import '../models.dart' as models;

class Orderpage extends StatefulWidget {
  String message;
  String orderNo;
  List<models.order_product_indent> listofProduct = [];

  Orderpage(this.message, this.orderNo);

  @override
  State<Orderpage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  Future getOrder;
  get_Order(orderNo) async {
    if (orderNo != '') {
      final url = Uri.parse(main.url_start +
          'mobileApp/orderDetails/' +
          orderNo +
          '/' +
          main.storage.getItem('branch') +
          '/');
      print(url.toString());
      final response = await http.get(url);
      //  print(response.statusCode);

      if (response.statusCode == 200) {
        //  print(response.body);
        var data = json.decode(response.body) as Map;
        return data;
      }
    } else {
      return null;
    }
  }

  List<TableRow> productList() {
    List<TableRow> list = [];
    if (widget.listofProduct != null) {
      print('@55 ' + widget.listofProduct.toString());
      list = widget.listofProduct.map<TableRow>((e) {
        return TableRow(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(e.product.toString())),
            ),
          ]),
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                      e.Quantity.toString() + '-' + e.UnitRate.toString())),
            )
          ]),
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.Discount.toString()),
            )
          ]),
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.Amount.toString()),
            )
          ]),
        ]);
      }).toList();
    } else {
      list = [
        TableRow(children: [
          Column(children: [
            Center(child: Text('')),
          ]),
          Column(children: [Center(child: Text(''))]),
          Column(children: [Text('')])
        ])
      ];
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder = get_Order(widget.orderNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Order'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            message.Message(widget.message),
            FutureBuilder(
                future: getOrder,
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.done:
                      print('@135' + snapshot.data.toString());
                      if (snapshot.data != null) {
                        widget.listofProduct = snapshot.data['Products']
                            .map<models.order_product_indent>((json) =>
                                models.order_product_indent.fromjson(json))
                            .toList();
                        print('@153 ' + widget.listofProduct.toString());
                        return Column(children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Customer: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['custName'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Date: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['Date'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Custcode: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['custCode'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Order No: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.orderNo.toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Total Amount: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['Amount'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Total Discount: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['Discount'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: SingleChildScrollView(
                                  child: Table(
                                    defaultColumnWidth: FixedColumnWidth(60.0),
                                    border: TableBorder.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    children: [
                                          TableRow(children: [
                                            Column(children: [
                                              Center(
                                                  child: Text('Prod',
                                                      style: TextStyle(
                                                          fontSize: 15.0)))
                                            ]),
                                            Column(children: [
                                              Center(
                                                  child: Text('Qty-Rate',
                                                      style: TextStyle(
                                                          fontSize: 15.0)))
                                            ]),
                                            Column(children: [
                                              Text('Disc',
                                                  style:
                                                      TextStyle(fontSize: 15.0))
                                            ]),
                                            Column(children: [
                                              Text('Amt',
                                                  style:
                                                      TextStyle(fontSize: 15.0))
                                            ]),

                                            // Column(children: [
                                            //   Text('Amt', style: TextStyle(fontSize: 15.0))
                                            // ]),
                                          ]),
                                        ] +
                                        productList(),
                                  ),
                                ),
                              )),
                            ),
                          ),
                        ]);
                      } else {
                        return CircleAvatar();
                      }
                  }
                })
          ]),
        ));
  }
}
