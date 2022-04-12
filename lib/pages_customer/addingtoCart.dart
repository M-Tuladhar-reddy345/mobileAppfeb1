// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_complete_guide/models.dart' as models;


class AddingToCartpage extends StatefulWidget {
  String message;
  Map<String, models.Customerprod> cart = {};
  int cartProds = 0;
  String prodtype;  
  StateSetter setModalState;

  @override
  State<AddingToCartpage> createState() => _AddingToCartpageState();
}

class _AddingToCartpageState extends State<AddingToCartpage> {
  Future getProducts;
  get_products() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getProducts_all/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.get(url);
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['products'];
    }
  }
  void add(pcode, unitrate){
      if (widget.cart[pcode] != null){
        setState(() {
         
        widget.cartProds = widget.cartProds+1;
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) + 1).toString();
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
      });
      
      }
     }
    void subtract(pcode, unitrate){
      if (widget.cart[pcode].Quantity != '0.0'){
        setState(() {
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) - 1).toString();
        widget.cartProds = widget.cartProds-1;
        
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
      });
      }
     }
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
                                
                              return TableRow(children: [
                                Column(children: [
                                  Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(height: 50,width: 50,color: Theme.of(context).primaryColorDark,child: Container(),),
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
                                  Center(child: Text(e.Amount, style: TextStyle(fontSize: 15.0)))
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
                            }).toList()
                            
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
    getProducts = get_products();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Order Now'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [

             FutureBuilder(future: getProducts,builder: (context, snapshot) {
               
               switch (snapshot.connectionState){
                 case ConnectionState.active:
                 return Container();
                 break;
                 case ConnectionState.waiting:
                 return CircularProgressIndicator();
                 case ConnectionState.done:
                 if( snapshot.data == null){
                   return Text('Not working');
                 }else{
                    
                    
                   return Column(children: snapshot.data.map<Widget>((e){
                      widget.cart.putIfAbsent(e['pcode'], () => models.Customerprod(
                        e['pcode'].toString(),
                        e['ptype'].toString(),
                        e['unitRate'].toString(),
                        0.0.toString(),
                        0.0.toString(),));
                   
                      
                     return Card(child: Row(children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(height: 100,width: 100,color: Theme.of(context).primaryColorDark,child: Container(),),
                       ),
                       Column(children: [Text(e['pname'], style: TextStyle(fontFamily: GoogleFonts.roboto().fontFamily, fontWeight: FontWeight.bold), ), Text(e['unitRate'].toString()),Row(children: [ElevatedButton(onPressed: ()=>subtract(e['pcode'], e['unitRate']), child: Text('-')),Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(child: Center(child: Text(widget.cart[e['pcode']].Quantity.toString())), color: Colors.white, width: 50,),
                       ),ElevatedButton(onPressed: ()=>
                         add(e['pcode'], e['unitRate'])
                       , child: Text('+')) ],),Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(children: [Text('Total: '),Container(child: Center(child: Text(widget.cart[e['pcode']].Amount.toString())), color: Colors.white, width: 100,), ]),
                       ),])
                     ],),color: Theme.of(context).primaryColorLight,);
                   }).toList());
                 }
                 break;
                 case ConnectionState.none:
                 return Container();
                 break;
               }

             }),
             
          ]),
        ),
        floatingActionButton: Stack(children:[ 
          FloatingActionButton(onPressed: ()=> showCart(context,setState), child: Icon(Icons.shopping_cart)),
          Positioned(top: 3,right: 4,child: Container(
            decoration:  new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
            width: 20,
            child: Center(child: Text(widget.cartProds.toString(),style: TextStyle(
                        backgroundColor: Colors.white,
               color: Colors.black,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500
            ),),),
          ))
          ]));
  }
}

