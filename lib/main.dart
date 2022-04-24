import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:provider/provider.dart' as provider;
import './pages_Operators/home.dart' as home;
import 'package:localstorage/localstorage.dart' as localstorage;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splashFiles/splashTest.dart';
import 'package:http/http.dart' as http;

final localstorage.LocalStorage storage =
    localstorage.LocalStorage('RaithannaDairy_local');



// final String url_start = 'http://www.jacknjill.solutions/';
// 
// final String url_start = 'http://192.168.1.10:8000/';
// final String url_start = 'http://localhost:8000/';
final String url_start = 'http://192.168.1.2:8000/';
main() {
  storage.clear();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BuildContext contextt;
  Timer timer;
  int seconds = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('45');
    print(storage.getItem('username'));
    
    
    }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (seconds  == 10){
          seconds  = 0;
          if (storage.getItem('role')=='Customer'){
            print('yes');
        submit();}
        stoptime();
        
        storage.clear();
      }else{
        
        seconds ++;
      print(seconds);
      
        
     }});
  }
  void stoptime(){
    timer.cancel();
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out expired'),backgroundColor: Colors.red,));
    navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (_)=> CustomerLoginpage()));
  }
  void submit() async {
     List products = storage.getItem('cart').values.map(( e){
                        return {'pcode': e.product, 'quantity': e.Quantity};
                      }).toList();
                      final body = {
                        'phone':storage.getItem('phone'),
                      'ttlAmt': storage.getItem('ttl'),
                      'cartProds': storage.getItem('products'),
                      'products':products
                    };
                    print(body);
                    var url = Uri.parse(url_start +
                        'mobileApp/Updatecart/' );
                    final response = await http.post(url,
                        headers: {"Content-Type": "application/json"},
                        encoding: Encoding.getByName("utf-8"),
                        body: json.encode(body));
                       
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      submit();
      storage.clear();   
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
      submit();
      startTimer();
        
      
    } else if (state == AppLifecycleState.paused) {
      submit();
    } else if (state == AppLifecycleState.resumed) {
      timer.cancel();
      
      seconds = 0 ;
      getCart();
      
      
      print('resumed');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(storage.getItem('phone'));
    // getCart();
    contextt = context;
    return MaterialApp(
      title: 'Raithanna Dairy', 
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        ))

      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
