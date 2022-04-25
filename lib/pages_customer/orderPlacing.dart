import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_Operators/login.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerSignup.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../models.dart' ;
import '../widgets/navbar.dart' as navbar;
import '../pages_Operators/home.dart' as home;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class OrderConfirm extends StatefulWidget {
  const OrderConfirm({ Key key }) : super(key: key);

  @override
  State<OrderConfirm> createState() => _BaseState();
}

class _BaseState extends State<OrderConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                                                                   
    );
  }
}