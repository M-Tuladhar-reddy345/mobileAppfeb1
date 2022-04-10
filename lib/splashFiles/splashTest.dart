import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_complete_guide/pages_Operators/home.dart';
import 'package:flutter_complete_guide/pages_common/login.dart';
import 'package:provider/provider.dart';
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
    await Future.delayed(Duration(seconds: 2));
    dispose();
    Navigator.pushReplacement(context, CustomPageRoute(child: Loginpage()));
  }
  
  @override
  Widget build(BuildContext context) {
    AlignmentTween _alignTween = AlignmentTween(begin: Alignment.center, end: Alignment.bottomCenter);
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Container(
        decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg_7.jpg"),
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
    );
  }
}