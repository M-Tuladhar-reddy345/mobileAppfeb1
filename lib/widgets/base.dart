import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_Operators/login.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerSignup.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models.dart' ;
import '../widgets/navbar.dart' as navbar;
import '../pages_common/home.dart' as home;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
class Base extends StatefulWidget {

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('base', Size(MediaQuery.of(context).size.width,56)),
      body: Container(),
    );
  }
}