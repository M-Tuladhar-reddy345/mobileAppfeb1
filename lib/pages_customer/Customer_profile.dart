import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:http/http.dart' as http;

import '../widgets/navbar.dart' as navbar;
// ignore: must_be_immutable
class Customer_profile extends StatefulWidget {
  String addressController;
  @override
  State<Customer_profile> createState() => _Customer_profileState();
}

class _Customer_profileState extends State<Customer_profile> {
  Future _getCustomer;
  updateAddress(address) async{
    Uri url = Uri.parse(url_start + 'mobileApp/updateAddress/');
    final response = await http.post(url,body:{'phone': storage.getItem('phone'),'address':address,'branch':storage.getItem('branch')});
    if ( response.statusCode == 200){
      _getCustomer = getCustomer();
      
    }
  }
  Future getCustomer() async{
    Uri url = Uri.parse(url_start+'mobileApp/getCustomerDetails_user/'+storage.getItem('phone').toString()+'/'+storage.getItem('branch').toString()+'/'); 
    final  response = await http.get(url);
    if (response.statusCode==200){
      final data = json.decode(response.body) as Map;
      return data;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCustomer = getCustomer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('Customer profile', Size(MediaQuery.of(context).size.width,56)),
      body: FutureBuilder(
        future: _getCustomer,
        // ignore: missing_return
        builder:(context, snapshot)  {
          print(snapshot.data);
          switch(snapshot.connectionState){
            
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              // TODO: Handle this case.
              return SingleChildScrollView(child: Column(
      children: [
        Align(alignment: Alignment.center,child: Text('Profile',style: Theme.of(context).primaryTextTheme.titleLarge.copyWith(color: Colors.black,))),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Customer Name',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                Text('Customer Code',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                Text('Mobile Number',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                Text('Email',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),]
                ),
                Column(
                children: [
                Text(':',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                Text(':',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                Text(':',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                Text(':',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),]
                ),
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(snapshot.data['custname'].toString(),style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                Text(snapshot.data['custcode'].toString(),style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                Text(storage.getItem('phone').toString(),style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                Text(snapshot.data['email'].toString(),style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),]
                ),
            ],),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: snapshot.data['address']!= null ?[
                 Align(alignment: Alignment.centerLeft,child: Text('Address: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(onChanged: (value){setState((){widget.addressController = value;});},decoration: InputDecoration(labelText: 'Address',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(color: Colors.white)))),
                ),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.toString()), child: Text('Update or add address'))
              ]:[
                Align(alignment: Alignment.centerLeft,child: Text('Address: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField( onChanged: (value){setState((){widget.addressController = value;});},decoration: InputDecoration(labelText: 'Address',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(color: Colors.white)))),
                ),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.toString()), child: Text('Update or add address'))
              ],
            ),
          ),
        )
      ],
      
      ),);
          }
        }
      
    ));
  }
}