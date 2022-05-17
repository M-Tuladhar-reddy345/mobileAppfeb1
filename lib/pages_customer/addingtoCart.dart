// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../commonApi/cartApi.dart';
import '../commonApi/commonApi.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_complete_guide/models.dart' as models;

import 'orderConfirming.dart';


class AddingToCartpage extends StatefulWidget {
  String message;
  Map<String, models.Customerprod> cart = {};
  int cartProds = 0;
  int ttlqty = 0;
  double ttlamt = 0;
  String prodtype = 'All';  
  List prodtypes=['All'];
  StateSetter setModalState;
  AddingToCartpage(String this.prodtype, List this.prodtypes);
  @override
  State<AddingToCartpage> createState() => _AddingToCartpageState();
}

class _AddingToCartpageState extends State<AddingToCartpage> {
  Future getProducts;
  
  void add(pcode, unitrate){
      if (widget.cart[pcode] != null){
        setState(() {
         
        widget.ttlqty = widget.ttlqty+1;
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) + 1).toString();
        if (widget.cart[pcode].Quantity == '1.0'){
          widget.cartProds = widget.cartProds+1;
        }

        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
        widget.ttlamt = widget.ttlamt + (double.parse(widget.cart[pcode].UnitRate));
       
        
      });
      main.storage.setItem('cart', widget.cart);
         main.storage.setItem('ttl', widget.ttlamt.toString());
         main.storage.setItem('products', widget.cartProds.toString());
         main.storage.setItem('ttlqty',widget.ttlqty.toString());
      }
     }
    void subtract(pcode, unitrate){
      if (widget.cart[pcode].Quantity != '0.0'){
        setState(() {
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) - 1).toString();
       
        if (widget.cart[pcode].Quantity == '0.0'){
          widget.cartProds = widget.cartProds-1;
        }
        widget.ttlqty = widget.ttlqty-1;
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
        widget.ttlamt = widget.ttlamt - (double.parse(widget.cart[pcode].UnitRate));
        
      });
      main.storage.setItem('cart', widget.cart);
        main.storage.setItem('ttl', widget.ttlamt.toString());
        main.storage.setItem('products', widget.cartProds.toString());
        main.storage.setItem('ttlqty',widget.ttlqty.toString());
      }
     }
    Widget showCart(BuildContext ctx,StateSetter setModalState){
      showModalBottomSheet(context: ctx, builder: (ctx){
        return StatefulBuilder(builder: ((context, setState) {
          
          return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children:[ 
                            ElevatedButton(onPressed: (){updatecart();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderConfirm() ));}, child: Text('Procced >')),
                            Container(
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
                                        child: Text(widget.ttlqty.toString(),                                style: TextStyle(fontSize: 15.0)))
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
                                          ),]
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
    if (main.storage.getItem('ttl') != null && main.storage.getItem('products') != null&& main.storage.getItem('cart') != null &&main.storage.getItem('ttlqty') != null ){
      widget.cart = main.storage.getItem('cart');
    widget.cartProds = int.parse(main.storage.getItem('products'));
    widget.ttlamt = double.parse(main.storage.getItem('ttl'));
    widget.ttlqty = int.parse(main.storage.getItem('ttlqty').toString());
    }
    return    Scaffold(       
        drawer: navbar.Navbar(),
        appBar: AppBarCustom('Add to cart', Size(MediaQuery.of(context).size.width,56)),
        body: SingleChildScrollView(
          child: Column(children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: DropdownButton(
                                      isExpanded: true,
                                      value: widget.prodtype,

                                      // icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        width: 300,
                                        color: Colors.red,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          widget.prodtype = newValue;
                                        });
                                      },
                                      items: widget.prodtypes
                                          .map<DropdownMenuItem<String>>((v) {
                                        return DropdownMenuItem<String>(
                                            value: v,
                                            child: Text(v.toString()));
                                      }).toList(),
                                    ),
           ),
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
                        0.0.toString(),
                        e['pimage'].toString(),
                        e['pname'].toString()),);
                      if (widget.prodtypes.contains(e['ptype'])==false){
                        widget.prodtypes.add(e['ptype']);
                      }
                      var image = e['pimage'];
                   
                     if(widget.prodtype == 'All'){ 
                     return Card(child: Row(children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child:  Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                       ),
                       Column(children: [Text(e['pname'], style: TextStyle( fontWeight: FontWeight.bold), ), Text('Rs.'+e['unitRate'].toString()),Row(children: [IconButton(onPressed: () => subtract(e['pcode'],e['unitRate']), icon:Icon( Icons.remove_circle, color: Theme.of(context).primaryColor,)),Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(child: Center(child: Text(widget.cart[e['pcode']].Quantity.toString())), color: Colors.white, width: 50,),
                       ),IconButton(onPressed: () => add(e['pcode'],e['unitRate']), icon:Icon( Icons.add_circle, color: Theme.of(context).primaryColor,))],),Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(children: [Text('Total: Rs.'),Container(child: Center(child: Text(widget.cart[e['pcode']].Amount.toString())), color: Colors.white, width: 100,), ]),
                       ),])
                     ],),color: Theme.of(context).primaryColorLight,);}
                     else if (widget.prodtype == e['ptype']){
                       return Card(child: Row(children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child:  Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                       ),
                       Column(children: [Text(e['pname'], style: TextStyle(fontFamily: GoogleFonts.roboto().fontFamily, fontWeight: FontWeight.bold), ), Text('Rs.'+e['unitRate'].toString()),Row(children: [IconButton(onPressed: () => subtract(e['pcode'],e['unitRate']), icon:Icon( Icons.remove_circle, color: Theme.of(context).primaryColor,)),Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(child: Center(child: Text(widget.cart[e['pcode']].Quantity.toString())), color: Colors.white, width: 50,),
                       ),IconButton(onPressed: () => add(e['pcode'],e['unitRate']), icon:Icon( Icons.add_circle, color: Theme.of(context).primaryColor,))
                        ],),Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(children: [Text('Total: Rs.'),Container(child: Center(child: Text(widget.cart[e['pcode']].Amount.toString())), color: Colors.white, width: 100,), ]),
                       ),])
                     ],),color: Theme.of(context).primaryColorLight,);
                     }else{
                       return Container();
                     }
                   
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
        //   Container(
        //   child: Text('Total: '+ widget.ttlamt.toString()),
        // ),
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

