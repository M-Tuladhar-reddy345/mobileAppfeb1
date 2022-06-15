import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_complete_guide/widgets/loader.dart';
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
  String refundRemark;
  RefundDialogbox(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter The reason'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 6,
                
                onChanged: (value) {
                  refundRemark = value;
                },
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                return refundRemark;
              },
              child: Text(
                'Submit',
              ),
            ),
          ],
        );
      });
      }
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
          widget.listofProduct = data['Products']
                            .map<models.order_product_indent>((json) =>
                                models.order_product_indent.fromjson(json))
                            .toList();
        });
        return data;
      }
    } else {
      return null;
    }
  }
  List<DataRow> productList_cust() {
    List<DataRow> list = [];
    if (widget.listofProduct != null) {
      list = widget.listofProduct.map<DataRow>((e) {
        return DataRow(cells: [
          DataCell(Text(e.product.toString())),
          DataCell(Text( e.Quantity.toString() + '-' + e.UnitRate.toString())),
          DataCell(Text(e.Discount.toString())),
          DataCell(Text(e.Amount.toString())),
          DataCell(Text(e.status.toString())),
          DataCell(Checkbox(value: e.Paid , onChanged: e.Paid == true ? null : (value){setState(() {
            if (e.Paid != true && (e.Delivered!=true || e.Refunded != true)){
              print('hello');
            widget.listofProduct[widget.listofProduct.indexOf(e)].Paid = value;}
          });}),),
          DataCell(Checkbox(value: e.Delivered , onChanged: (value){setState(() {
            
            if (e.PDelivered != true && e.PRefunded != true&& e.Refunded != true ){
            widget.listofProduct[widget.listofProduct.indexOf(e)].Delivered = value;}
          });}),),
          DataCell(Checkbox(value: e.Refunded , onChanged: (value){setState(() {
             if (e.PRefunded != true && e.PDelivered != true && e.Delivered != true){
            
            widget.listofProduct[widget.listofProduct.indexOf(e)].Refunded = value;}
          });}),),
          DataCell(ElevatedButton(child: Text('-->'),onPressed: e.Paid != e.PPaid || e.Delivered != e.PDelivered || e.Refunded != e.PRefunded ? ()async{
             LoaderDialogbox(context);
             final url = Uri.parse(main.url_start +
          'mobileApp/statupdate_prodwise/' +
          e.orderNo.toString() +
           '/'+
           e.custcode+
          '/' +
          main.storage.getItem('branch').toString() +
          '/' +
          e.product.toString() +
          '/' +
          e.Delivered.toString() +
          '/'+e.Refunded.toString() +'/');
      print(url.toString());
      final response = await http.get(url);
      //  print(response.statusCode);

      if (response.statusCode == 200) {
        //  print(response.body);
        var data = json.decode(response.body) as Map;
        if( data['message'] == 'Success'){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SuccessFully updated'),backgroundColor: Colors.green,));
          getOrder =get_Order(widget.orderNo);
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update'),backgroundColor: Colors.red,));
        }
        
      }

          }:null,)),

        
      ]);}).toList();
    }
    return list;
  }
   List<DataRow> productList_staff() {
    List<DataRow> list = [];
    if (widget.listofProduct != null) {
      list = widget.listofProduct.map<DataRow>((e) {
        return DataRow(cells: [
          DataCell(Text(e.product.toString())),
          DataCell(Text( e.Quantity.toString() + '-' + e.UnitRate.toString())),
          DataCell(Text(e.Discount.toString())),
          DataCell(Text(e.Amount.toString())),
          
        

      ]);}).toList();
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
                           
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                  child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(color: Colors.black),
                                    columns: [
                                          DataColumn(label: Text('Prod')),
                                          DataColumn(label: Text('Qty-Rate')),
                                          DataColumn(label: Text('Disc'),numeric: true),
                                          DataColumn(label: Text('Amt'),numeric: true),
                                          DataColumn(label: Text('Status')),
                                          DataColumn(label: Text('Paid ')),
                                          DataColumn(label: Text('Delivered')),
                                          DataColumn(label: Text('Refund')),
                                          DataColumn(label: Text('Update')),
                                          
                                        ] ,
                                        rows: productList_cust()
                                        // productList(),
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
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    columns: [
                                          DataColumn(label: Text('Prod')),
                                          DataColumn(label: Text('Qty-Rate')),
                                          DataColumn(label: Text('Disc'),numeric: true),
                                          DataColumn(label: Text('Amt'),numeric: true),
                                        ] ,
                                        rows: productList_staff(),
                                        // productList(),
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
