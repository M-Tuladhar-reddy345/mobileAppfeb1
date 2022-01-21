import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages/home.dart';
import './models.dart';
import 'package:http/http.dart' as http;
import './main.dart' as main;
import './models.dart' as models;

class CustomerProvider with ChangeNotifier {
  CustomerProvider() {
    get_customers();
  }

  List<models.Customer> _Customers = [];

  List<models.Customer> get Customers {
    return [..._Customers];
  }

  get_customers() async {
    final url = Uri.parse(main.url_start + 'mobileApp/CustomerDetails/');
    final response = await http.get(url);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      //print(response.body);
      var data = json.decode(response.body) as Map;
      //print(data['results']);

      _Customers = data['results']
          .map<models.Customer>((json) => models.Customer.fromjson(json))
          .toList();
    }
  }
}

class RecieptProvider {
  String RecieptNo = '';
  String Date = '';
  List RecTypes = [];
  String Payement = '';
  double RecAmt = 0;
  double Waiver = 0;
  String Remarks = '';

  get_Reciept(custcode) async {
    final url =
        Uri.parse(main.url_start + 'mobileApp/RecieptDetails/' + custcode);
    final response = await http.get(url);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
      var data = json.decode(response.body) as Map;
      //print(data['results']);
      this.RecieptNo = data['RecieptNo'].toString();
      this.Date = data['Date'].toString();
      this.RecTypes = data['Rectypes'];
      this.Payement = data['payRefNo'].toString();
      this.RecAmt = data['RecAmt'];
      this.Waiver = data['Waiver'];
      this.Remarks = data['Remarks'].toString();
    }
  }
}
