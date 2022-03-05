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
                        color: Colors.blue,
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
                        color: Colors.blue,
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
