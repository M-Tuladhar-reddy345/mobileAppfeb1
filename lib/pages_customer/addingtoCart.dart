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
  AddingToCartpage();

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
          
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) + 1).toString();
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
      });
      }else {
        widget.cart[pcode] = models.Customerprod(
          pcode,
          unitrate,
          1.toString(),
          unitrate.toString()
        ); 
      }
     }
    void subtract(pcode, unitrate){
      if (widget.cart[pcode].Quantity != '0.0'){
        setState(() {
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) - 1).toString();
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
      });
      }
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
          title: Text('Add to cart'),
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

             })
  
          ]),
        ));
  }
}

