// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages_Operators/DownloadPdfIndent.dart';
import 'package:flutter_complete_guide/pages_Operators/Edit_updatePayements.dart';
import 'package:flutter_complete_guide/pages_Operators/dailySalesEntry.dart';

import 'package:flutter_complete_guide/pages_Operators/ExtractdailyIndent.dart';
import 'package:flutter_complete_guide/pages_Operators/edit_dailySalesEntry.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerSignup.dart';
import 'package:flutter_complete_guide/pages_customer/cart.dart';
import '../main.dart' as main;
import '../pages_Operators/home.dart' as home;
import '../pages_Operators/UpdatePayments.dart' as UpdatePayments;
import '../pages_Operators/login.dart' as login;
import '../pages_Operators/login.dart' as loginCustomer;
import 'package:http/http.dart' as http;

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(main.storage.getItem('username'));
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: main.storage.getItem('username') == null
            ? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image(
                          width: 800,
                          height: 180,
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
                            builder: (context) => home.Homepage()),
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
                            builder: (context) => CustomerLoginpage()),
                      );
                    },
                  ),
                  
                  ListTile(
                    title: const Text('Customer Sign Up'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUppage()),
                      );
                    },
                  ),
                ],
              )
            :main.storage.getItem('role')=='Admin' || main.storage.getItem('role') =='Manager'? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image(
                          width: 800,
                          height: 180,
                          image:
                              AssetImage('assets/images/RaithannaOLogo.png'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      main.storage.getItem('username').toString() +
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
                            builder: (context) => home.Homepage()),
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
                            builder: (context) => DailySalesEntrypage()),
                      );
                    },
                  ),
                   ListTile(
                    title: const Text('Edit Daily Sales Entry'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDailySalesEntrypages_Operatorstate()),
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
                            builder: (context) => PdfIndentpage()),
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
                            builder: (context) => ExtractdailyIndentpage()),
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
                                UpdatePayments.UpdatePayments()),
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
                            builder: (context) => editUpdatePayements()),
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
                        main.storage.setItem('username', null);

                        main.storage.setItem('branch', null);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out succesfully'),backgroundColor: Colors.green,));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomerLoginpage()),
                        );
                      }
                    },
                  ),
                ],
              ): main.storage.getItem('role') =='Operator'? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image(
                          width: 800,
                          height: 180,
                          image:
                              AssetImage('assets/images/RaithannaOLogo.png'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      main.storage.getItem('username').toString() +
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
                            builder: (context) => home.Homepage()),
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
                            builder: (context) => DailySalesEntrypage()),
                      );
                    },
                  ),ListTile(
                    title: const Text('Edit Daily Sales Entry'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDailySalesEntrypages_Operatorstate()),
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
                            builder: (context) => PdfIndentpage()),
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
                            builder: (context) => ExtractdailyIndentpage()),
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
                        main.storage.setItem('username', null);

                        main.storage.setItem('branch', null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  home.Homepage()),
                        );
                      }
                    },
                  ),
                ],
              ):main.storage.getItem('role') =='SalesTeam'? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image(
                          width: 800,
                          height: 180,
                          image:
                              AssetImage('assets/images/RaithannaOLogo.png'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      main.storage.getItem('username').toString() +
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
                            builder: (context) => home.Homepage()),
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
                                UpdatePayments.UpdatePayments()),
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
                            builder: (context) => editUpdatePayements()),
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
                        main.storage.setItem('username', null);

                        main.storage.setItem('branch', null);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out succesfully'),backgroundColor: Colors.green,));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomerLoginpage()),
                        );
                      }
                    },
                  ),
                ],
              ):main.storage.getItem('role') =='Customer'?ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image(
                          width: 800,
                          height: 180,
                          image:
                              AssetImage('assets/images/RaithannaOLogo.png'))),
                  //  Image(

                  //     image:
                  //         AssetImage('assets/images/RaithannaOLogo.jpg'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      main.storage.getItem('username').toString() +
                          '@' +
                          main.storage.getItem('role').toString(),
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
                            builder: (context) => home.Homepage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Cart'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cartpage()),
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
                        main.storage.setItem('username', null);

                        main.storage.setItem('branch', null);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out succesfully'),backgroundColor: Colors.green,));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomerLoginpage()),
                        );
                      }
                    },
                  ),
                ],
              ):ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                      decoration: BoxDecoration(
                        color:Colors.white,
                      ),
                      child: Image(
                          width: 800,
                          height: 180,
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
                            builder: (context) => home.Homepage()),
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
                        main.storage.setItem('username', null);

                        main.storage.setItem('branch', null);
                        main.storage.setItem('phone', null);
                        main.storage.setItem('role', null);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out succesfully'),backgroundColor: Colors.green,));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomerLoginpage()),
                        );
                      }
                    },
                  ),
                ],
              ));
  }
}
