// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../main.dart' as main;
import '../pages/home.dart' as home;
import '../pages/UpdatePayments.dart' as UpdatePayments;
import '../pages/login.dart' as login;

class Navbar extends StatefulWidget {
  String message;
  int messageNumber = 0;

  //String user = main.storage.getItem('User_item');

  Navbar(this.message);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    // print(main.storage.getItem('salesName'));
    return Column(children: [
      Container(
          color: Theme.of(context).primaryColorDark,
          child: Row(children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: main.storage.getItem('salesName') != null
                      ? [
                          Container(
                            // width: MediaQuery.of(context).size.width / 2,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                home.Homepage('')),
                                      );
                                    },
                                    child: Text(
                                      'Home',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdatePayments.UpdatePayments(
                                                    '')),
                                      );
                                    },
                                    child: Text(
                                      'Update payments',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      main.storage.setItem('salesName', null);

                                      main.storage.setItem('branch', null);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => home.Homepage(
                                                'logged out successfully')),
                                      );
                                    },
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      : [
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => home.Homepage('')),
                              );
                            },
                            child: Text(
                              'Home',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login.Loginpage('')),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
            ),
          ])),
      widget.message != '' || widget.messageNumber == 1
          ? Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                widget.message,
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              color: Colors.lightGreenAccent)
          : Container()
    ]);
  }
}

// class _NavbarState extends State<Navbar> {
//   @override
//   Widget build(BuildContext context) {
//     print(main.storage.getItem('User_phone'));
//     return Column(
//       children: [
//         Container(
//             color: Theme.of(context).primaryColorDark,
//             child: main.storage.getItem('User_phone') != null
//                 ? Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width * 80 / 100,
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                                 //crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   FlatButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 home.Homepage(widget.message)),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Home',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ]),
//                           ),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 widget.message = '';
//                               });
//                             },
//                             icon: Icon(
//                               Icons.refresh_sharp,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                   )
//                 : Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width * 80 / 100,
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                                 //crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   FlatButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 home.Homepage(widget.message)),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Home',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   FlatButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 login.Loginpage(
//                                                     widget.message)),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Login',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   FlatButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 register.Registerpage(
//                                                     widget.message)),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Register',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ]),
//                           ),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 widget.message = '';
//                               });
//                             },
//                             icon: Icon(
//                               Icons.refresh_sharp,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                   )),
//         widget.message != ''
//             ? Container(
//                 width: MediaQuery.of(context).size.width,
//                 alignment: Alignment.center,
//                 child: Text(
//                   widget.message,
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 color: Colors.lightGreenAccent)
//             : Container()
//       ],
