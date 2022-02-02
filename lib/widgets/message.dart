import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../main.dart' as main;
import '../pages/home.dart' as home;
import '../pages/UpdatePayments.dart' as UpdatePayments;
import '../pages/login.dart' as login;

class Message extends StatefulWidget {
  String message;
  Message(this.message);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return widget.message != ''
        ? Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text(
              widget.message,
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            color: Colors.lightGreenAccent)
        : Container();
  }
}
