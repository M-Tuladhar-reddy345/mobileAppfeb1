import 'package:flutter/material.dart';

Widget LoaderDialogbox (BuildContext context){
  showDialog(context: context, builder: (context){
    return Container(
      width: 50,
      child: new AlertDialog(content: SizedBox(
        height: 0.5,       width: 50,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      )),
    );
  });
}