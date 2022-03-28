import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import './pages_Operators/home.dart' as home;
import 'package:localstorage/localstorage.dart' as localstorage;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';


final localstorage.LocalStorage storage =
    localstorage.LocalStorage('RaithannaDairy_local');

// final String url_start = 'http://www.jacknjill.solutions/';
// 
// final String url_start = 'http://192.168.1.10:8000/';
// final String url_start = 'http://localhost:8000/';
final String url_start = 'http://192.168.1.3:8000/';
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
    }
  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (seconds  == 360){
          seconds  = 0;
        stoptime();
        storage.clear();
      }else{
        
        seconds ++;
      print(seconds);
      
        
     }});
  }
  void stoptime(){
    timer.cancel();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out expired'),backgroundColor: Colors.red,));
    navigatorKey.currentState.push(MaterialPageRoute(builder: (_)=> home.Homepage()));
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      print('detached');
      storage.clear();
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
      startTimer();
    } else if (state == AppLifecycleState.paused) {
      print('paused');
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
    contextt = context;
    return MaterialApp(
      title: 'Raithanna Dairy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.openSans().fontFamily,
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: GoogleFonts.quicksand().fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        ))

      ),
      home: home.Homepage(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
