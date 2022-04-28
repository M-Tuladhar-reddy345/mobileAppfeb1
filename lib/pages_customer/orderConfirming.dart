import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import '../models.dart' ;
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_complete_guide/models.dart' as models;

class OrderConfirm extends StatefulWidget {
  String message;
  Map<String, models.Customerprod> cart = {};
  int cartProds = 0;
  double ttlamt = 0;
  String prodtype = 'All';  
  List prodtypes=['All'];
  StateSetter setModalState;
  String Address1;
  String Address2;
  String Address3;
  String Address4;
  
  @override
  State<OrderConfirm> createState() => _OrderConfirm();
}

class _OrderConfirm extends State<OrderConfirm> {
  Future getAddresses;
  get_addresses() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getAddresses/' );
    final response = await http.get(url);
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['addresses'];
    }
  }
  
  // ignore: missing_return
  Widget showCart(BuildContext ctx,StateSetter setModalState){
      showModalBottomSheet(context: ctx, builder: (ctx){
        return StatefulBuilder(builder: ((context, setState) {
          
          return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                      child: Container(
                    width: MediaQuery.of(ctx).size.width,
                    height: 400,
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
                                    child: Text('Qty',
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Text('Amt', style: TextStyle(fontSize: 15.0))
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]),
                          ] + widget.cart.values.map((e){
                            print(e.product);
                            print(widget.cart.length);
                            if( e.Quantity != '0.0' ){
                            var image = e.pImage;
                            return TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(height: 50,width: 50,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                                        ),
                                        Text(e.product,
                                          style: TextStyle(fontSize: 15.0)),
                      
                                      ])
                              )]),
                              Column(children: [
                                Center(
                                    child: SizedBox(
                                      width: 30,
                                      child: Center(
                                        child: Text(e.Quantity,
                                          style: TextStyle(fontSize: 15.0)),
                                      ),
                                    ))
                              ]),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(alignment: Alignment.centerRight,child: Text(e.Amount, style: TextStyle(fontSize: 15.0))),
                                )
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]);}else{  
                            return TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Container()
                              )]),
                              Column(children: [
                                Center(
                                    child: Container())
                              ]),
                              Column(children: [
                                Center(child: Container())
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]);}
                          }).toList()+[
                            TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Text('Total',
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Center(
                                    child: Text('',
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(alignment: Alignment.centerRight,child: Text(widget.ttlamt.toString(), style: TextStyle(fontSize: 15.0))),
                                )
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]),
                          ]
                          
                        ),
                    ),
                  )),
                );
        }));
        
      });
    }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddresses = get_addresses();
  }
  @override
  Widget build(BuildContext context) {
    widget.cart = main.storage.getItem('cart') ;
    widget.cartProds = int.parse(main.storage.getItem('products'));
    widget.ttlamt = double.parse(main.storage.getItem('ttl'));
    return Scaffold(
    drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Confirm order'),
          
        ),
        body: SingleChildScrollView(child: Column(
          children: [
            Center(child: FlatButton(onPressed: ()=> showCart(context,setState), child: Text('Show products', style: TextStyle(color: Theme.of(context).primaryColor),))),
            Text('Total:- '+ widget.ttlamt.toString(), style: TextStyle(fontSize: 20),),
            Text('Total products:- '+ widget.cartProds.toString(), style: TextStyle(fontSize: 20),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 2,width: MediaQuery.of(context).size.width * (90/100),color: Theme.of(context).primaryColorLight,),
            ),
            Align(alignment: Alignment.centerLeft,child: Text('Address', style: TextStyle(fontSize: 15),)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText:'Flatno/Apartment/floor' 
                ),
                onChanged:(value){
                  setState(() {
                  widget.Address1 = value;  
                  });                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText:'Street' 
                ),
                onChanged:(value){
                  setState(() {
                  widget.Address2 = value;  
                  });                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText:'colony/City' 
                ),
                onChanged:(value){
                  setState(() {
                  widget.Address3 = value;  
                  });                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText:'District/State/Pincode' 
                ),
                onChanged:(value){
                  setState(() {
                  widget.Address4 = value;  
                  });                  
                },
              ),
            ),       
            FutureBuilder(future: getAddresses,builder: (context, snapshot) {
              
            })   
            ]
        )));

  }
}