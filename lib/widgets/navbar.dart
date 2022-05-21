// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/commonApi/cartApi.dart';
import 'package:flutter_complete_guide/pages_Operators/DownloadPdfIndent.dart';
import 'package:flutter_complete_guide/pages_Operators/Edit_updatePayements.dart';
import 'package:flutter_complete_guide/pages_Operators/dailySalesEntry.dart';

import 'package:flutter_complete_guide/pages_Operators/ExtractdailyIndent.dart';
import 'package:flutter_complete_guide/pages_Operators/edit_dailySalesEntry.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerSignup.dart';
import 'package:flutter_complete_guide/pages_customer/DownloadSoa.dart';
import 'package:flutter_complete_guide/pages_customer/cart.dart';
import 'package:flutter_complete_guide/pages_customer/wallet.dart';
import '../main.dart' as main;
import '../pages_common/home.dart' as home;
import '../pages_Operators/UpdatePayments.dart' as UpdatePayments;
import 'package:http/http.dart' as http;

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(main.storage.getItem('username'));
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        
        child: Column(
          children : [
            const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Image(
                              width: 800,
                              height: 180,
                              image:
                                  AssetImage('assets/images/RaithannaOLogo.png'))),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                                        // Important: Remove any padding from the ListView.
                                                        children: main.storage.getItem('username') == null ? <Widget>[
                                                          
                                                          //  Image(
                                                
                                                          //     image:
                                                          //         AssetImage('assets/images/RaithannaOLogo.jpg'))),
                                                          ListTile(
                                                            title: const Text('Home'),
                                                            onTap: () {
                                                              // Update the state of the app.
                                                              // ...
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => SignUppage()),
                                                              );
                                                            },
                                                          ),
                                                        ]            
                                                    :main.storage.getItem('role')=='Admin' || main.storage.getItem('role') =='Manager'? <Widget>[
                                                          
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerLoginpage()),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ]
                                                    : main.storage.getItem('role') =='Operator'? <Widget>[
                                                          
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                      builder: (context) =>
                                          home.Homepage()),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ]:main.storage.getItem('role') =='SalesTeam'? <Widget>[
                                                          
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                              Navigator.pushReplacement(
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
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerLoginpage()),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ]:main.storage.getItem('role') =='Customer' ||main.storage.getItem('phone') !=null  ? <Widget>[
                                                          
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
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => home.Homepage()),
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: const Text('Wallet'),
                                                            onTap: () {
                                                              // Update the state of the app.
                                                              // ...
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => Wallet()),
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: const Text('Cart'),
                                                            onTap: () {
                                                              // Update the state of the app.
                                                              // ...
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => Cartpage()),
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: const Text('Get SOA'),
                                                            onTap: () {
                                                              // Update the state of the app.
                                                              // ...
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => PdfSoaCustomer()),
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: const Text('Logout'),
                                                            onTap: () async {
                                                              updatecart();
                                                              final url =    Uri.parse(main.url_start + 'mobileApp/logout/');
                                                              final response = await http.get(url);
                                                              //  print(response.statusCode);
                                                
                                                              if (response.statusCode == 200) {
                                                                main.storage.setItem('username', null);
                                                
                                                                main.storage.setItem('branch', null);
                                                                main.storage.clear();
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out succesfully'),backgroundColor: Colors.green,));
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerLoginpage()),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ]: <Widget>[
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
                                                              Navigator.pushReplacement(
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
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerLoginpage()),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        
                                                        ]
                                                          
                                                        
                                                        
                                                      ),
                                    ),
                                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Expanded(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Wrap(
                          
                          children: [
                            Image(image: AssetImage("assets/images/jnjlogo.png"),
                            height: 50,
                            width: 50,
                    // color: Color(0xFF3A5A98),
               ),
                            Text('Copyright©2022 - All rights reserved to Jack n Jill Solutions Pvt Ltd',style:TextStyle(color: Theme.of(context).primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  )
        ]));
         
        
  }
}
