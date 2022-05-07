import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_complete_guide/pages_Operators/home.dart';
import 'package:flutter_complete_guide/pages_Operators/login.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/splashFiles/splash2.dart';
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
    Navigator.pushReplacement(context, CustomPageRoute(child: Splash2()));
  }
  
  @override
  Widget build(BuildContext context) {
    AlignmentTween _alignTween = AlignmentTween(begin: Alignment.center, end: Alignment.bottomCenter);
    return    Scaffold(       
      bottomNavigationBar: Container(
                        color: Theme.of(context).primaryColor,
                        child: Stack(
                          
                          children: [
                            Image(image: AssetImage("assets/images/jnjlogo.png"),
                            height: 60,
                            width: 60,
                    // color: Color(0xFF3A5A98),
               ),
                            Positioned(left: 60,child: Text(' Copyright ©2022 All rights reserved \n Jack n Jill Solutions Pvt.Ltd. \n JacknJill.me.',style:TextStyle(color: Theme.of(context).primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ),
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
    );
  }
}