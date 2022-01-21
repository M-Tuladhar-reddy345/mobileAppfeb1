import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;

class Homepage extends StatefulWidget {
  String message;

  Homepage(this.message);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Raithanna Dairy'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            navbar.Navbar(widget.message),
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