import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/splashFiles/splash2.dart';
import '../widgets/Pageroute.dart';

class Splash extends StatefulWidget {
  
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{
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
    Navigator.pushReplacement(context, CustomPageRoute(child: Splash2()));
  }
  
  @override
  Widget build(BuildContext context) {
    AlignmentTween _alignTween = AlignmentTween(begin: Alignment.center, end: Alignment.bottomCenter);
    return    Scaffold(
      backgroundColor: Colors.white,
      
      body: Container(
        decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_7.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedAlign(
          duration: Duration(seconds: 1),
          alignment: change? Alignment.bottomCenter : Alignment.center,
          child: Image(
                        image:
                            AssetImage('assets/images/RaithannaOLogo.png')),
        ),
        
      ),
      floatingActionButton:FloatingActionButton(child: Icon(Icons.skip_next), onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:((context) => CustomerLoginpage())),)
    ));
  }
}