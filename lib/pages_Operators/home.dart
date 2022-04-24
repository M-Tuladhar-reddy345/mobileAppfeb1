import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/pages_customer/addingtoCart.dart';
import 'package:flutter_complete_guide/pages_customer/cart.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:flutter_complete_guide/main.dart' as main;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_complete_guide/models.dart';


class Homepage extends StatefulWidget {
  String message;

  Homepage();

  @override
  State<Homepage> createState() => _HomepageState();
  
}

class _HomepageState extends State<Homepage> {
  List homeImages = [
    'bg_11.jpeg',
    'bg_12.jpeg',
    'bg_13.jpg',
    'bg_14.jpg',
  ];
  Future getprodtypes;
  get_produtypes() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getprodtypes/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.get(url);
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['prodtypes'];
    }
  }
  getCart() async{
    final body = {
      'phone': storage.getItem('phone')
    };
    final url = Uri.parse(url_start +
        'mobileApp/getCart/' );
    final response = await http.post(url, body: body);
    if (response.statusCode == 200){
      final data = json.decode(response.body) as Map;
      print(data);
      Map<String,Customerprod> cart = {};
      
      
      
      if (data['products'] == ''){
      storage.setItem('ttl', data['ttl']);
      storage.setItem('products', data['cartprods']);
      storage.setItem('cart',  <String,Customerprod> {} );}else{
        List products = data['products'] as List;
       for (var e in products){
        print(e);
        cart.putIfAbsent(e['pcode'], () => Customerprod(
                        e['pcode'].toString(),
                        e['ptype'].toString(),
                        e['unitRate'].toString(),
                        e['quantity'].toString(),
                        e['amount'].toString(),
                        e['pimage'].toString(),
                        e['pname'].toString()),);
      }
      print("@89");
      print(cart);
 storage.setItem('ttl', data['ttl']);
      storage.setItem('products', data['cartprods']);
      storage.setItem('cart',  cart);
      }}
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprodtypes = get_produtypes();
    print(storage.getItem('ttl'));
    print(storage.getItem('phone'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
             ImageSlideshow(
          width: double.infinity ,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {
            debugPrint('Page changed: $value');
          },
          autoPlayInterval: 3000,
          isLoop: true,
          children: homeImages.map((e) {
            return Image(image: AssetImage('assets/images/$e'));
          }).toList()
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Cartpage())));
            },
            child: Row(children: [
              Icon(Icons.shopping_cart, size: 50,color: Theme.of(context).primaryColor,),
              Column(
                children: [
                  Text('Products: '+ main.storage.getItem('products').toString(), style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20,color: Colors.black))
                  ,Text('Total Amt: '+ main.storage.getItem('ttl').toString(), style: TextStyle(fontWeight: FontWeight.w100, color: Colors.grey),)
                ],
              )
            ]),
            
          ),
        ),
        FutureBuilder(
          future: getprodtypes,
          // ignore: missing_return
          builder: (context, snapshot) {
             switch (snapshot.connectionState){
                 case ConnectionState.active:
                 return Container();
                 break;
                 case ConnectionState.waiting:
                 return CircularProgressIndicator();
                 case ConnectionState.done:
                 if( snapshot.data == null){
                   return Text('Some error in backend will catch up later');
                 }else{
                   return Wrap(children: snapshot.data.map<Widget>((e){
                     var image = e['imgname'];
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ElevatedButton(
                         style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
                         onPressed: (){Navigator.pushReplacement(context, CustomPageRoute(child: AddingToCartpage(e['ptype'],['All',e['ptype']])));},
                         child: Column(children: [
                           Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                         ),
                         Text(e['pname'])
                         ]),
                       ),
                     );
                   }).toList());
                 }
                 break;
               case ConnectionState.none:
               return Container();
                 // TODO: Handle this case.
                 break;
          }})
                 
          ])));
  }
}

