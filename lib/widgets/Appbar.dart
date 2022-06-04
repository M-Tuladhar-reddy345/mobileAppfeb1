import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/pages_customer/wallet.dart';

// ignore: must_be_immutable
class AppBarCustom extends StatelessWidget implements PreferredSizeWidget{
  String title;
  @override
    final Size preferredSize;  
  AppBarCustom(this.title, this.preferredSize);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          backgroundColor: Colors.red,
          leading: Image(image: AssetImage("assets/images/RaithannaOLogo.jpg"),
                    // color: Color(0xFF3A5A98),
               ),
          title: Text(title),
          actions: storage.getItem('role') == 'Customer'?[IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Wallet()));}, icon: Image(image:AssetImage('assets/icons/wallet.png'))),IconButton(onPressed: (){
            Scaffold.of(context).openDrawer();
          }, icon: Icon(Icons.menu))]
          :[IconButton(onPressed: (){
            Scaffold.of(context).openDrawer();
          }, icon: Icon(Icons.menu))],
          centerTitle: true,
        );
  }
  
  
  
}