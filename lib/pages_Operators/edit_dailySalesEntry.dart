import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
import 'package:flutter_complete_guide/pages_Operators/Order.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'reciept.dart' as receipt;

import 'package:dropdown_search/dropdown_search.dart';

class EditDailySalesEntrypages_Operatorstate extends StatefulWidget {
  String message;
  final ValueNotifier<String> dropdownValue2 = ValueNotifier<String>('');
  String custCode;
  String dropdownValue;
  String orderNo;
  
  String pamt = '0';
  String pRate = '0';
  final ValueNotifier<String> product2 = ValueNotifier<String>('');
  String product;
  String prodCode;
  var quantity_controller = TextEditingController()..text = '0';
  var discount_controller = TextEditingController()..text = '0';
  var remarks_controller = TextEditingController()..text = ' ';
  List<models.order_product_indent> listofProduct = [];
  EditDailySalesEntrypages_Operatorstate();
  int prodNo = 0;
  bool customerIgnore = false;
  DateTime dateTime = DateTime.now();
  DateTime dateTimefrom = DateTime.now();
  DateTime dateTimeto = DateTime.now();
  
  @override
  State<EditDailySalesEntrypages_Operatorstate> createState() => _EDitDailySalesEntrypages_Operatorstate();
}

class _EDitDailySalesEntrypages_Operatorstate extends State<EditDailySalesEntrypages_Operatorstate> {
  Future getOrders;
  Future getProducts;
  Future getCustomer;
  
  get_orders(custcode) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    final url = Uri.parse(main.url_start +
        'mobileApp/getOrders/' +
        main.storage.getItem('branch') +
        '/'+
        datefrom.toString()+'/'+
        dateto.toString()+'/'+
        custcode.toString()+"/");
    final response = await http.get(url);

    //  print(response.statusCode);

    if (response.statusCode == 200) {
      //  print(response.body);
      var data = json.decode(response.body) as Map;
      

      return data['results'];
    }
  }
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

  get_products() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getProducts/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.get(url);
    // print(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      
      // print(data['results']);

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();

      return data['results'];
    }
  }

 

  void UpdateAmount() async {
    var body = {};
    if (widget.discount_controller.text != '' &&
        widget.quantity_controller.text != '') {
      body = {
        'custCode': widget.custCode,
        'Date': DateFormat("y-M-d").format(widget.dateTime),
        'prodCode': widget.prodCode,
        'qty': widget.quantity_controller.text,
        'disc': widget.discount_controller.text,
      };
    } else {
      body = {
        'custCode': widget.custCode,
        'Date': DateFormat("y-M-d").format(widget.dateTime),
        'prodCode': widget.prodCode,
        'qty': '0',
        'disc': '0',
      };
    }
    print('@129'+body.toString());
    final url = Uri.parse(main.url_start +
        'mobileApp/getAmtRate/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.post(url, body: body);
    print(url);

    // print('@121 ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      print(data);
      setState(() {
        widget.pamt = data['amt'].toString();
        widget.pRate = data['product'].toString();
      });
    }
  }

  void update() {
    setState(() {
        print('update');
        
        setState(() {
        widget.prodNo = widget.prodNo + 1;
          widget.discount_controller.text;
          widget.listofProduct[int.parse(widget.product)] = models.order_product_indent(
            widget.listofProduct[int.parse(widget.product)].date,
            widget.listofProduct[int.parse(widget.product)].product,
            widget.listofProduct[int.parse(widget.product)].orderNo,
            widget.pRate,
            widget.quantity_controller.text,
            widget.discount_controller.text,
            widget.pamt,
            widget.listofProduct[int.parse(widget.product)].Remarks,
            widget.listofProduct[int.parse(widget.product)].custcode,
            widget.listofProduct[int.parse(widget.product)].Id);
        });
        print(widget.listofProduct[int.parse(widget.product)].get_dict());
      
    });
  }

  void submit() async {
    if (widget.custCode != null){
    var body = {'results':{},'orderno':widget.dropdownValue,'username':main.storage.getItem('username')};

    var results = {};
    print(widget.listofProduct.length);
    for (int i = 0; i <= widget.listofProduct.length - 1; i++) {
      results[widget.listofProduct[i].product + '-' + widget.listofProduct[i].Id] =
          widget.listofProduct[i].get_dict();
    }
    body['results'] = results;
    print(json.encode(body));
    final url = Uri.parse(main.url_start +
        'mobileApp/DailySale_update/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName("utf-8"),
        body: json.encode(body));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map;
      if (data['message'].contains('Successfully')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('updated successfully ' + data['orderNo'].toString()), backgroundColor: Colors.green,));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Orderpage(data['orderNo'])),
        );
      } else {
        setState(() {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString()), backgroundColor: Colors.red,));
        });
      }
    } else {
      setState(() {
        
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Retry'), backgroundColor: Colors.red,));
      });
    }}else{
      
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please choose customer'), backgroundColor: Colors.red,));
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
    }}

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
    super.initState();
    getOrders = get_orders(widget.custCode);
    getOrder = get_Order(widget.orderNo);
    getProducts = get_products();
    getCustomer = get_customers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Edit Daily Sales Entry'),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
              
              Text(
                'Edit Daily Sales Entry',
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
                              if(snapshot.data != null){
                                return Container(
                                  width: 300,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: widget.custCode,

                                    // icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.lightBlue),
                                    underline: Container(
                                      height: 2,
                                      width: 300,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        widget.custCode = newValue;
                                      });
                                    },
                                    items: snapshot.data
                                        .map<DropdownMenuItem<String>>((v) {
                                      return DropdownMenuItem<String>(
                                          value: v.custCode.toString(),
                                          child: Text(v.custName.toString() +
                                              '-' +
                                              v.custCode.toString() ));
                                    }).toList(),
                                  ),
                                );} else{
                                  return Text('Retry');
                                  }
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
                Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
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
                              widget.dateTimefrom = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimefrom),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            Text(
              'To',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
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
                              widget.dateTimeto = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimeto),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            RaisedButton(onPressed: (){
              setState(() {
                getOrders = get_orders(widget.custCode);
              });
            }, color: Theme.of(context).primaryColor,child: Text(
                        'Get Orders',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),),

                 
                 Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: FutureBuilder(
                            future: getOrders,
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
                                    print(snapshot.data);
                                    return Row(
                                      children:[ Text('Order No: '),Container(
                                        width: 210,
                                        child: IgnorePointer(
                                          ignoring: widget.customerIgnore,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: widget.dropdownValue,
                                    
                                            // icon: const Icon(Icons.arrow_downward),
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.lightBlue),
                                            underline: Container(
                                              height: 2,
                                              width: 300,
                                              color: Colors.lightBlueAccent,
                                            ),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                widget.dropdownValue = newValue;
                                                getOrder=get_Order(widget.dropdownValue);
                                              });
                                            },
                                            items: snapshot.data
                                                .map<DropdownMenuItem<String>>(
                                                    (v) {
                                              return DropdownMenuItem<String>(
                                                  value: v[0].toString(),
                                                  child: Text(v[0].toString()+'-'+v[1].toString())
                                                  );
                                            }).toList(),
                                          ),
                                        ),
                                      ),]
                                    );
                                  } else {
                                    return Text(
                                        'Some error fetching pls try later');
                                  }
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
                      ),
                 Padding
                 (
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                                    width: MediaQuery.of(context).size.width,
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
                                  ),
                 ),
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
                        
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Container(child: Text('Order No: '+ widget.dropdownValue.toString(),style: TextStyle(fontSize: 20),),),
                            
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                 children: [Text('Product: '),Container(
                                                    width: 210,
                                                   child: DropdownButton(
                                                     
                                                        isExpanded: true,
                                                        value: widget.product,
                                               
                                                        // icon: const Icon(Icons.arrow_downward),
                                                        elevation: 16,
                                                        style: const TextStyle(
                                                            color: Colors.lightBlue),
                                                        underline: Container(
                                                          height: 2,
                                                          width: 300,
                                                          color: Colors.lightBlueAccent,
                                                        ),
                                                        onChanged: (String newValue) {
                                                          setState(() {
                                                            widget.product = newValue;
                                                            widget.prodCode = widget.listofProduct[int.parse(newValue)].product;
                                                            widget.pamt = widget.listofProduct[int.parse(newValue)].Amount;
                                                            widget.pRate = widget.listofProduct[int.parse(newValue)].UnitRate;
                                                            widget.quantity_controller.text = widget.listofProduct[int.parse(newValue)].Quantity;
                                                            widget.discount_controller.text = widget.listofProduct[int.parse(newValue)].Discount;
                                                          });
                                                        },
                                                        items: widget.listofProduct
                                                            .map<DropdownMenuItem<String>>(
                                                                (v) {
                                                          return DropdownMenuItem<String>(
                                                              value: widget.listofProduct.indexOf(v).toString(),
                                                              child: Text(v.product.toString())
                                                              );
                                                        }).toList(),
                                                      ),
                                                 
                                               ),
                                 ]),
                             ),
                             Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Amount: ' + widget.pamt.toString(),
                              style: TextStyle(fontSize: 20),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'UnitRate: ' + widget.pRate.toString(),
                              style: TextStyle(fontSize: 20),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: widget.quantity_controller,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                UpdateAmount();
                              },
                              decoration: InputDecoration(
                                labelText: "Quantity",
                                hintText: "Quantity",
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: widget.discount_controller,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                UpdateAmount();
                              },
                              decoration: InputDecoration(
                                labelText: "Discount",
                                hintText: "Discount",
                              )),
                        ),
                        
                        Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () => update(),
                          child: Text(
                            'update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: ()=>submit(),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
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
                      ])
                          ]),
                        );
                      }else if( snapshot.data == null){ 
                        return Text('choose order no');
                      } else {
                        return CircularProgressIndicator();
                      }
                  }
                })
              ]),
              
             
              

        ])])
        ));
  }
}
