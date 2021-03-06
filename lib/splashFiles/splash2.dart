import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import '../widgets/Pageroute.dart';

class Splash2 extends StatefulWidget {
  
  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> with TickerProviderStateMixin{
  bool change = true;
  AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateTohome();
  }
  _navigateTohome()async{
    setState(() {
      change = !change;
    });
    await Future.delayed(Duration(seconds: 3));
    dispose();
      Navigator.pushReplacement(context, CustomPageRoute(child: CustomerLoginpage()));
    
    
  }
  
  @override
  Widget build(BuildContext context) {
    return    Scaffold(       
      backgroundColor: Colors.white,
      
      body: Container(
        decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_8.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedAlign(
          duration: Duration(seconds: 1),
          alignment: Alignment.bottomCenter,
          child: Image(
                        image:
                            AssetImage('assets/images/RaithannaOLogo.png')),
        ),
        
      ),
      floatingActionButton:FloatingActionButton(child: Icon(Icons.skip_next), onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:((context) => CustomerLoginpage())),)
    ));
  }
}