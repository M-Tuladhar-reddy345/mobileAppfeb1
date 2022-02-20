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
final String url_start = 'http://192.168.20.10:8000/';
main() {
  storage.clear();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
