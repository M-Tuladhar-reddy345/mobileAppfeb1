// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages/DownloadPdfIndent.dart';
import 'package:flutter_complete_guide/pages/Edit_updatePayements.dart';
import 'package:flutter_complete_guide/pages/dailySalesEntry.dart';

import 'package:flutter_complete_guide/pages/ExtractdailyIndent.dart';
import '../main.dart' as main;
import '../pages/home.dart' as home;
import '../pages/UpdatePayments.dart' as UpdatePayments;
import '../pages/login.dart' as login;
import 'package:http/http.dart' as http;

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(main.storage.getItem('salesName'));
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: main.storage.getItem('salesName') == null
            ? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                      ),
                      child: Image(
                          width: 200,
                          height: 60,
                          image:
                              AssetImage('assets/images/RaithannaOLogo.png'))),
                  //  Image(

                  //     image:
                  //         AssetImage('assets/images/RaithannaOLogo.jpg'))),
                  ListTile(
                    title: const Text('Home'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => home.Homepage('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Login'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => login.Loginpage('')),
                      );
                    },
                  ),
                ],
              )
            : ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                      ),
                      child: Image(
                          width: 200,
                          height: 60,
                          image:
                              AssetImage('assets/images/RaithannaOLogo.png'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      main.storage.getItem('salesName').toString() +
                          '@' +
                          main.storage.getItem('branch').toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => home.Homepage('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Update Payments'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdatePayments.UpdatePayments('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Edit Update Payments'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => editUpdatePayements('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Daily Sales Entry'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailySalesEntrypage('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Download Daily Indent Report'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfIndentpage('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Extract Daily Indent'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExtractdailyIndentpage('')),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      // Update the state of the app.
                      // ...
                      final url =
                          Uri.parse(main.url_start + 'mobileApp/logout/');
                      final response = await http.get(url);
                      //  print(response.statusCode);

                      if (response.statusCode == 200) {
                        main.storage.setItem('salesName', null);

                        main.storage.setItem('branch', null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  home.Homepage('logged out successfully')),
                        );
                      }
                    },
                  ),
                ],
              ));
  }
}
// class _NavbarState extends State<Navbar> {
//   @override
//   Widget build(BuildContext context) {
//     // print(main.storage.getItem('salesName'));
//     return Column(children: [
//       Container(
//           color: Theme.of(context).primaryColorDark,
//           child: Row(children: [
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                   //crossAxisAlignment: CrossAxisAlignment.stretch,

//                   children: main.storage.getItem('salesName') != null
//                       ? [
//                           Container(
//                             // width: MediaQuery.of(context).size.width / 2,
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Row(
//                                 children: [
//                                   FlatButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 home.Homepage('')),
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
//                                                 UpdatePayments.UpdatePayments(
//                                                     '')),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Update payments',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   FlatButton(
//                                     onPressed: () {
//                                       main.storage.setItem('salesName', null);

//                                       main.storage.setItem('branch', null);
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => home.Homepage(
//                                                 'logged out successfully')),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Logout',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ]
//                       : [
//                           FlatButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => home.Homepage('')),
//                               );
//                             },
//                             child: Text(
//                               'Home',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           FlatButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => login.Loginpage('')),
//                               );
//                             },
//                             child: Text(
//                               'Login',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ]),
//             ),
//           ])),
//       widget.message != '' || widget.messageNumber == 1
//           ? Container(
//               width: MediaQuery.of(context).size.width,
//               alignment: Alignment.center,
//               child: Text(
//                 widget.message,
//                 style: TextStyle(color: Colors.green, fontSize: 20),
//               ),
//               color: Colors.lightGreenAccent)
//           : Container()
//     ]);
//   }
// }

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
