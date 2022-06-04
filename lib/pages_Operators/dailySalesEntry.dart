import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
import 'package:flutter_complete_guide/pages_Operators/Order.dart';
import '../widgets/Appbar.dart';
import '../widgets/navbar.dart' as navbar;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DailySalesEntrypage extends StatefulWidget {
  String message;
  final ValueNotifier<String> dropdownValue2 = ValueNotifier<String>('');
  String custCode;
  String dropdownValue;
  String orderNo;
  String pamt = '0';
  String pRate = '0';
  final ValueNotifier<String> product2 = ValueNotifier<String>('');
  String product;
  var quantity_controller = TextEditingController()..text = '0';
  var discount_controller = TextEditingController()..text = '0';
  var remarks_controller = TextEditingController()..text = ' ';
  List<models.order_product_indent> listofProduct = [];
  DailySalesEntrypage();
  int prodNo = 0;
  bool customerIgnore = false;
  DateTime dateTime = DateTime.now();

  @override
  State<DailySalesEntrypage> createState() => _DailySalesEntrypages_Operatorstate();
}

class _DailySalesEntrypages_Operatorstate extends State<DailySalesEntrypage> {
  Future getCustomer;
  Future getOrderNo;
  Future getProducts;
  get_customers() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/CustomerDetailsDS/' +
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

  get_orderNo() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getOrderNo/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.get(url);

    //  print(response.statusCode);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
      print(data);
      setState(() {
        widget.listofProduct = widget.listofProduct.map((e) {
          e.update_orderNo(data['orderNo'].toString());
          return e;
        }).toList();
        widget.orderNo = data['orderNo'].toString();
      });
      return data['orderNo'].toString();
    } else {
      return null;
    }
  }

  void UpdateAmount() async {
    var body = {};
    if (widget.discount_controller.text != '' &&
        widget.quantity_controller.text != '') {
      body = {
        'custCode': widget.dropdownValue,
        'Date': DateFormat("y-M-d").format(widget.dateTime),
        'prodCode': widget.product,
        'qty': widget.quantity_controller.text,
        'disc': widget.discount_controller.text,
      };
    } else {
      body = {
        'custCode': widget.dropdownValue,
        'Date': DateFormat("y-M-d").format(widget.dateTime),
        'prodCode': widget.product,
        'qty': '0',
        'disc': '0',
      };
    }
    // print(body);
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

  void add() {
    setState(() {
      if (widget.quantity_controller.text == '0') {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Qty cant be zero'), backgroundColor: Colors.red,));
      } else {
         
        widget.listofProduct.add(models.order_product_indent(
            widget.dateTime,
            widget.product,
            widget.orderNo,
            widget.pRate,
            widget.quantity_controller.text,
            widget.discount_controller.text,
            widget.pamt,
            widget.remarks_controller.text + '-Upd Thru App',
            widget.dropdownValue,
            widget.prodNo.toString()));
        widget.prodNo = widget.prodNo + 1;
        setState(() {
          widget.customerIgnore = true;
        });
      }
    });
  }

  void submit() async {
    if (widget.dropdownValue != null){
    var body = {'results':{},'orderno':widget.orderNo,'username':main.storage.getItem('username')};

    var results = {};
    print(widget.listofProduct.length);
    for (int i = 0; i <= widget.listofProduct.length - 1; i++) {
      results[widget.listofProduct[i].product + '-' + widget.listofProduct[i].Id] =
          widget.listofProduct[i].get_dict();
    }
    body['results'] = results;
    final url = Uri.parse(main.url_start +
        'mobileApp/DailySale_receive/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName("utf-8"),
        body: json.encode(body));
      print(response.statusCode);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map;
      if (data['message'].contains('Successfully')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message']), backgroundColor: Colors.green,));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Orderpage(data['orderNo'])),
        );
      } else {
        setState(() {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message']), backgroundColor: Colors.red,));
        });
      }
    } else {
      setState(() {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Retry'), backgroundColor: Colors.red,));
      });
    }}else{
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Choose a customer'), backgroundColor: Colors.red,));
      });
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
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red, fontSize: 10),
                ),
                onPressed: () {
                  setState(() {
                    widget.listofProduct.remove(e);
                  });
                },
              ),
            )
          ])
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
    getCustomer = get_customers();
    getOrderNo = get_orderNo();
    getProducts = get_products();
    this.setState(() {
      widget.orderNo = getOrderNo.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBarCustom('Daily Sales Entry', Size(MediaQuery.of(context).size.width,56)),
          
        body: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Column(children: [
              Text(
                'Daily Sales Entry',
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(children: [
                            Text('Customer: '),
                            FutureBuilder(
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
                                    if (snapshot.data != null) {
                                      print('@332' +
                                          widget.customerIgnore.toString());
                                      return Container(
                                        width: 210,
                                        child: IgnorePointer(
                                          ignoring: widget.customerIgnore,
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
                                              });
                                            },
                                            items: snapshot.data
                                                .map<DropdownMenuItem<String>>(
                                                    (v) {
                                              return DropdownMenuItem<String>(
                                                  value: v.custCode.toString(),
                                                  child: Text(v.custName
                                                          .toString() +
                                                      '-' +
                                                      v.custCode.toString()));
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text(
                                          'Some error fetching pls try later');
                                    }
                                }
                              },
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Text(
                            'Order No: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          FutureBuilder(
                              future: getOrderNo,
                              // ignore: missing_return
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Container(
                                      child: CircularProgressIndicator(),
                                    );
                                  case ConnectionState.done:
                                    if (snapshot.data != null) {
                                      widget.orderNo = snapshot.data.toString();

                                      return Container(
                                        child: Text(snapshot.data,
                                            style: TextStyle(fontSize: 20)),
                                      );
                                      break;
                                    } else {
                                      return Text(
                                          'Some error fetching pls try later');
                                    }
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                                child: Icon(Icons.replay),
                                onPressed: () {
                                  setState(() {
                                    getOrderNo = get_orderNo();
                                  });
                                }),
                          )
                        ]),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    'Pick Date',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
                                          widget.listofProduct =
                                              widget.listofProduct.map((e) {
                                            e.update_date(value);
                                            return e;
                                          }).toList();
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                            child: Row(children: [
                              Text('Product:'),
                              FutureBuilder(
                                future: getProducts,
                                // ignore: missing_return
                                builder: (context, snapshot) {
                                  print(snapshot.connectionState);
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
                                            value: widget.product,

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
                                                if (widget.dropdownValue !=
                                                    null) {
                                                  widget.product = newValue;
                                                   
                                                } else {
                                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select customer first'), backgroundColor: Colors.red,));
                                                }
                                                // widget.product2.value = newValue;
                                              });
                                              UpdateAmount();
                                            },
                                            items: snapshot.data
                                                .map<DropdownMenuItem<String>>(
                                                    (v) {
                                              return DropdownMenuItem<String>(
                                                  value: v['Code'].toString(),
                                                  child: Text(v['Name']
                                                          .toString() +
                                                      '-' +
                                                      v['Unit'].toString()));
                                            }).toList(),
                                          ),
                                        );
                                      } else {
                                        return Text(
                                            'Some error fetching pls try later');
                                      }
                                      break;
                                    case ConnectionState.none:
                                      // TODO: Handle this case.
                                      return Container(
                                        width: 30,
                                        child: CircularProgressIndicator(),
                                      );
                                    case ConnectionState.active:
                                      // TODO: Handle this case.
                                      return Container(
                                        width: 30,
                                        child: CircularProgressIndicator(),
                                      );
                                  }
                                },
                              ),
                            ]),
                          ),
                        ),
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
                          child: TextFormField(
                              controller: widget.remarks_controller,
                              decoration: InputDecoration(
                                labelText: "Remarks",
                                hintText: "Remarks",
                              )),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () => add(),
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () => submit(),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
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
                                          style: TextStyle(fontSize: 15.0)))
                                ]),
                                Column(children: [
                                  Center(
                                      child: Text('Qty-Rate',
                                          style: TextStyle(fontSize: 15.0)))
                                ]),
                                Column(children: [
                                  Text('Disc', style: TextStyle(fontSize: 15.0))
                                ]),
                                Column(children: [
                                  Text('Amt', style: TextStyle(fontSize: 15.0))
                                ]),
                                Column(children: [
                                  Text('Rem', style: TextStyle(fontSize: 15.0))
                                ]),
                                // Column(children: [
                                //   Text('Amt', style: TextStyle(fontSize: 20.0))
                                // ]),
                              ]),
                            ] +
                            productList(),
                      ),
                    ),
                  )),
                )
              ])
            ]))));
  }
}