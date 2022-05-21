import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/commonApi/cartApi.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:localstorage/localstorage.dart' as localstorage;
import 'package:google_fonts/google_fonts.dart';
import 'splashFiles/splashTest.dart';

final localstorage.LocalStorage storage =
    localstorage.LocalStorage('RaithannaDairy_local');


// final String url_start = 'http://www.jacknjill.solutions/';
// final String url_start = 'http://192.168.1.103:8000/';
// final String url_start = 'http://192.168.1.10:8000/';
// final String url_start = 'http://localhost:8000/';
// final String url_start = 'http://192.168.1.2:8000/';
final String url_start = 'http://192.168.225.117:8000/';

// final String url_start = 'http://192.168.29.70:8000/';
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
      if (seconds  == 360){
          seconds  = 0;
          
        stoptime();
        storage.setItem('role', null);
      storage.setItem('phone', null);
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
  
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      if (storage.getItem('role')=='Customer'){
            print('yes');
        updatecart();}
      storage.clear();  
      storage.setItem('role', null);
      storage.setItem('phone', null); 
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
      if (storage.getItem('role')=='Customer'){
            print('yes');
        updatecart();}
      
      startTimer();
        
      
    } else if (state == AppLifecycleState.paused) {
      
    } else if (state == AppLifecycleState.resumed) {
      timer.cancel();
      
      seconds = 0 ;
      
      
      
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
        primaryTextTheme: TextTheme(
          titleSmall: TextStyle(color: Colors.white,fontSize: 16,fontFamily: GoogleFonts.aBeeZee().fontFamily),
          titleLarge: TextStyle(color: Colors.white,fontSize: 28,fontFamily: GoogleFonts.aBeeZee().fontFamily),
          titleMedium: TextStyle(color: Colors.white,fontSize: 20,fontFamily: GoogleFonts.aBeeZee().fontFamily),
          ),
        primarySwatch: Colors.red,
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        appBarTheme: AppBarTheme(toolbarTextStyle: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        ).bodyText2, titleTextStyle: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        ).headline6)

      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
