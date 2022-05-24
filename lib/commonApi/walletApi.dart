import 'package:http/http.dart' as http;
import 'package:flutter_complete_guide/main.dart'as main;
import 'dart:convert';

import 'package:razorpay_flutter/razorpay_flutter.dart';
// ignore: missing_return
Future<List> getWallet()async{
  final Map body = {
    'phone':main.storage.getItem('phone')
  };
  final response = await http.post(Uri.parse(main.url_start+'mobileApp/getWallet/'), body: body);
  if (response.statusCode==200){
    final data= json.decode(response.body) as Map;
    if (data['message'] == 'success'){
      print(data);
      // setState(() {
      //   widget.balance = data['balance'];
      //   widget.wallet_id = data['wallet_id'];
      // });
      return [data['balance'],data['wallet_id']];
    }
  }
}
openRazorpay( razorpay,amt) async{
    final url = Uri.parse(main.url_start +
        'mobileApp/razorPayordercreate/'+amt +'/'+main.storage.getItem('phone')+'/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
    
      razorpay.open({
        'key': main.Razorpay_key_id,
        'amount': int.parse(data['amt']), //in the smallest currency sub-unit.
        'name': 'Raithanna milk Dairy ',
        'order_id': data['orderid'], // Generate order_id using Orders API
        'description': 'Fresh milk and milk products',
        'timeout': main.Razorpay_timeout, // in seconds
        'prefill':{
          'contact':main.storage.getItem('phone')
        }
      });
      }
  }
Future rechargeWallet(amt)async{

  final response = await http.get(Uri.parse(main.url_start+'mobileApp/rechargeWallet/'+amt.toString() +'/'+main.storage.getItem('phone')+'/'));
  if (response.statusCode==200){
    final data= json.decode(response.body) as Map;
    if (data['message'] == 'success'){
      print(data);
      // setState(() {
      //   widget.balance = data['balance'];
      //   widget.wallet_id = data['wallet_id'];
      // });
      return [data['balance'],data['wallet_id']];
    }
  }
}
Future PaywithWallet(amt)async{

  final response = await http.get(Uri.parse(main.url_start+'mobileApp/paymentWallet/'+amt.toString() +'/'+main.storage.getItem('phone')+'/'));
  if (response.statusCode==200){
    final data= json.decode(response.body) as Map;
    if (data['message'] == 'success'){
      print(data);
      // setState(() {
      //   widget.balance = data['balance'];
      //   widget.wallet_id = data['wallet_id'];
      // });
      return [data['balance'],data['wallet_id'],data['message'],data['orderno']];
    }
  }
}