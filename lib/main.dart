import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import './pages/home.dart' as home;
import 'package:localstorage/localstorage.dart' as localstorage;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'api.dart' as api;

final localstorage.LocalStorage storage =
    localstorage.LocalStorage('RaithannaDairy_local');

// final String url_start = 'http://www.jacknjill.solutions/';
// final String url_start = 'http://localhost:8000/';
final String url_start = 'http://192.168.1.10:8000/';
main() {
  storage.clear();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // TODO: implement didChangeAppLifecycleState
  //   super.didChangeAppLifecycleState(state);

  //   if (state == AppLifecycleState.detached) {
  //     print('ditached');
  //     storage.clear();
  //   } else if (state == AppLifecycleState.inactive) {
  //     print('inactive');
  //     storage.clear();
  //   } else if (state == AppLifecycleState.paused) {
  //     print('paused');
  //     storage.clear();
  //   } else if (state == AppLifecycleState.resumed) {
  //     print('resumed');
  //     storage.clear();
  //   }
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raithanna Dairy',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "OpenSans",
      ),
      home: home.Homepage(''),
      debugShowCheckedModeBanner: false,
    );
  }
}
