import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/commonApi/walletApi.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/pages_customer/addingtoCart.dart';
import 'package:flutter_complete_guide/pages_customer/cart.dart';
import 'package:flutter_complete_guide/pages_customer/wallet.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import '../widgets/navbar.dart' as navbar;
import 'package:flutter_complete_guide/main.dart' as main;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_complete_guide/models.dart';


class Homepage extends StatefulWidget {
  String message;
  int cartProds = 0;
  int ttlqty = 0;
  double ttlamt = 0;
  Homepage();

  @override
  State<Homepage> createState() => _HomepageState();
  
}


class _HomepageState extends State<Homepage> {
  Future _getWalet;
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
  Widget minimumWallet(){
    // ignore: missing_return
    return FutureBuilder(future: _getWalet,builder: (context,snapshot){
          switch (snapshot.connectionState){

            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
            print(223);
            print(snapshot.data);
             if (snapshot.data[0] < 500){
              return Padding(
                padding: const EdgeInsets.only(left:30, right: 30),
                child: Card(child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.warning, size: 30,color: Color.fromARGB(255, 121, 2, 14),),
                    
                  ),
                  Flexible(child: Text('Your wallet balance is low!!! \nRecharge it', style: Theme.of(context).primaryTextTheme.titleSmall.copyWith(color:Color.fromARGB(255, 121, 2, 14) ),))
                ],),),
              ) ;
             }else{return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Wallet()));
              },
               child: Center(child: Container(
                width: MediaQuery.of(context).size.width - 60,
                 child: Card(shape: RoundedRectangleBorder(borderRadius:BorderRadius.all( Radius.circular(40))),color: Theme.of(context).primaryColor,child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Image(image:AssetImage('assets/icons/Balanceruppe2.png')),
                      Text(snapshot.data[0].toString()+'/-', style: Theme.of(context).primaryTextTheme.titleMedium,),
                      Text('View Wallet', style: Theme.of(context).primaryTextTheme.titleMedium,)])),
               ),),
             );}

          }
        },);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getWalet = getWallet(); 
    getprodtypes = get_produtypes();
  }
  @override
  Widget build(BuildContext context) {
    print(main.storage.getItem('ttl'));
    print(main.storage.getItem('products'));
    if (main.storage.getItem('ttlqty')!=null && main.storage.getItem('ttl') != null && main.storage.getItem('products') != null){
    widget.cartProds = int.parse(main.storage.getItem('products'));
    widget.ttlamt = double.parse(main.storage.getItem('ttl'));
    widget.ttlqty = int.parse(main.storage.getItem('ttlqty').toString());
    }
    return    Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBarCustom('Home', Size(MediaQuery.of(context).size.width, 56)),
        body: SingleChildScrollView(
          child: Column(children: main.storage.getItem('role') != 'Customer'? <Widget>[
             ImageSlideshow(
          width: double.infinity ,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.red,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {
            debugPrint('Page changed: $value');
          },
          autoPlayInterval: 3000,
          isLoop: true,
          children: homeImages.map((e) {
            return Image(image: AssetImage('assets/images/$e'));
          }).toList()
        )] : widget.cartProds == 0 ? <Widget>[
             ImageSlideshow(
          width: double.infinity ,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.red,
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
        
         minimumWallet(),
       
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
                         style: ElevatedButton.styleFrom(primary: Colors.redAccent),
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
                 
          ]:[
             ImageSlideshow(
          width: double.infinity ,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.red,
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

        // ignore: missing_return
        minimumWallet(),
         Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: GestureDetector(
            onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Cartpage())));},
            child: Container(
              height: 90,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    // Icon(Icons.shopping_cart, size: 50,color: Theme.of(context).primaryColor,),
                    Image(image:AssetImage('assets/icons/shopping-bag.png')),
                    Container(
                      padding: const EdgeInsets.only(left:40, top: 10),
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Products: '+widget.cartProds.toString()+'('+widget.ttlqty.toString()+')' , style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20,color: Colors.black))
                          ,Text('Total Amt: '+  widget.ttlamt.toString(), style: TextStyle(fontWeight: FontWeight.w100, color: Colors.grey),)
                        ],
                      ),
                    )
                  ]),
                ),
                elevation:30,
                shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                margin: EdgeInsets.all(2),
              ),
            ),
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
                       child: GestureDetector(
                         
                         onTap: (){Navigator.pushReplacement(context, CustomPageRoute(child: AddingToCartpage(e['ptype'],['All',e['ptype']])));},
                         child: Container(
                           height:160,
                           width:150,
                           child: Card(
                             elevation:5,
                             color: Colors.redAccent,
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                             child: Column(children: [
                               Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                             ),
                             Text(e['pname'], style: Theme.of(context).primaryTextTheme.titleSmall,)
                             ]),
                           ),
                         ),
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

