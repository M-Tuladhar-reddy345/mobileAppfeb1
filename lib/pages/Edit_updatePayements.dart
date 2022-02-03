import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/models.dart' as models;
import 'package:flutter_complete_guide/pages/Order.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import '/api.dart' as api;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'reciept.dart' as receipt;
import '../widgets/message.dart' as message;

class editUpdatePayements extends StatefulWidget {
  String message;

  DateTime dateTime = DateTime.now();
  editUpdatePayements(this.message);

  @override
  State<editUpdatePayements> createState() => _editUpdatePayementsState();
}

class _editUpdatePayementsState extends State<editUpdatePayements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Edit Update Payments'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            message.Message(widget.message),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Pick Date',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime.now())
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                widget.dateTime = value;
                              });
                            }
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat("d-M-y").format(widget.dateTime),
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {

//   AnimationController _animationController;

//   @override
//   void initState() {
//      super.initState();
//     _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
//     _animationController.addListener((){
// 		  setState((){});
// 	  });
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//      super.dispose();
//     _animationController.dispose();
//   }
// }
