import 'package:flutter/material.dart';
import '../widgets/Appbar.dart';
import '../widgets/navbar.dart' as navbar;
import '../main.dart' as main;
import 'dart:convert';


import 'package:http/http.dart' as http;
import '../models.dart' as models;

class Orderpage extends StatefulWidget {
  String orderNo;
  List<models.order_product_indent> listofProduct = [];
  bool paid = false;
  bool delivered = false;
  bool ppaid = false;
  bool pdelivered = false;
  Orderpage(this.orderNo);

  @override
  State<Orderpage> createState() => _Orderpages_Operatorstate();
}

class _Orderpages_Operatorstate extends State<Orderpage> {
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
        setState(() {
          widget.paid = data['paid'].toString() == 'true';
          widget.delivered = data['delv'].toString() == 'true';
          widget.ppaid = data['paid'].toString() == 'true';
          widget.pdelivered = data['delv'].toString() == 'true';
        });
        return data;
      }
    } else {
      return null;
    }
  }

  List<TableRow> productList() {
    List<TableRow> list = [];
    if (widget.listofProduct != null) {
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
        appBar: AppBarCustom('Order', Size(MediaQuery.of(context).size.width,56)),
        body: SingleChildScrollView(
          child: Column(children: [
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
                      if (snapshot.data != null) {
                        widget.listofProduct = snapshot.data['Products']
                            .map<models.order_product_indent>((json) =>
                                models.order_product_indent.fromjson(json))
                            .toList();
                        
                        return Column(children:snapshot.data['source'].toString() == 'CustBook' ? <Widget>[
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Status: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['status'].toString(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ])),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Paid: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Checkbox(value: widget.paid , onChanged: (value){setState(() {
                                  if (widget.ppaid != true){
                                  widget.paid = value;}
                                });})
                              ])),
                               Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  'Delivered: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Checkbox(value: widget.delivered , onChanged: (value){setState(() {
                                  if (widget.pdelivered != true){
                                  widget.delivered = value;}
                                });})
                              ])),
                              RaisedButton(onPressed: widget.ppaid == true&& widget.delivered!= true && snapshot.data['status'].toString() =='Paid'? () async{
                                final url = Uri.parse(main.url_start +
                                    'mobileApp/refund_order_request/' +
                                    widget.orderNo +
                                    '/' +
                                    main.storage.getItem('branch') +
                                    '/');
                                print(url.toString());
                                final response = await http.get(url);
                                if (response.statusCode == 200){
                                 final data = json.decode(response.body) as Map;
                                  if( data['message'] == 'Success'){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SuccessFully requested refund'),backgroundColor: Colors.green,));
                                    getOrder =get_Order(widget.orderNo);
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update'),backgroundColor: Colors.red,));
                                  }
                                }
                              }:null , child: Text('Refund', style: Theme.of(context).primaryTextTheme.titleMedium), color: Theme.of(context).primaryColor,),
                              RaisedButton(onPressed: (main.storage.getItem('role')=='Admin' || main.storage.getItem('role') =='Manager')&& snapshot.data['status'].toString() == 'PRefund' ? () async{
                                final url = Uri.parse(main.url_start +
                                    'mobileApp/refund_order_accept/' +
                                    widget.orderNo +
                                    '/' +
                                    main.storage.getItem('branch') +
                                    '/');
                                print(url.toString());
                                final response = await http.get(url);
                                if (response.statusCode == 200){
                                 final data = json.decode(response.body) as Map;
                                 print(data);
                                  if( data['message'].toString() == 'Success'){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message2'].toString()),backgroundColor: Colors.green,));
                                    getOrder =get_Order(widget.orderNo);
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update'),backgroundColor: Colors.red,));
                                  }
                                }
                              }:null , child: Text('Accept Refund', style: Theme.of(context).primaryTextTheme.titleMedium), color: Theme.of(context).primaryColor,),
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
                        ]: <Widget>[
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: widget.paid != widget.ppaid || widget.delivered != widget.pdelivered ? 
        FlatButton(onPressed: ()=>updateStatus(), child: Container(height: 50,width: 100,child: Center(child: Text('Update',style: Theme.of(context).primaryTextTheme.titleLarge,))),color: Theme.of(context).primaryColor,)
        :Container(),
        );
  }
void updateStatus()async{
  final url = Uri.parse(main.url_start +
          'mobileApp/statusupdate/' +
          widget.paid.toString() +
          '/' +
          widget.delivered.toString() +
          '/' +
          widget.orderNo.toString() +
          '/' +
          main.storage.getItem('branch') +
          '/');
      print(url.toString());
      final response = await http.get(url);
      //  print(response.statusCode);

      if (response.statusCode == 200) {
        //  print(response.body);
        var data = json.decode(response.body) as Map;
        if( data['message'] == 'Success'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SuccessFully updated'),backgroundColor: Colors.green,));
          getOrder =get_Order(widget.orderNo);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update'),backgroundColor: Colors.red,));
        }
        
      }
}
}
