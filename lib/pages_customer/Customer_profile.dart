import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:http/http.dart' as http;

import '../widgets/navbar.dart' as navbar;
// ignore: must_be_immutable
class Customer_profile extends StatefulWidget {
  TextEditingController addressController = TextEditingController();
  TextEditingController Address1 = TextEditingController()..text = '';
  TextEditingController Address2 = TextEditingController()..text = '';
  TextEditingController Address3 = TextEditingController()..text = '';
  TextEditingController Address4 = TextEditingController()..text = '';
  TextEditingController pincode = TextEditingController()..text = '';
  @override
  State<Customer_profile> createState() => _Customer_profileState();
}

class _Customer_profileState extends State<Customer_profile> {
  Future _getCustomer;
  updateAddress(address) async{
    Uri url = Uri.parse(url_start + 'mobileApp/updateAddress/');
    final response = await http.post(url,body:{
      'phone': storage.getItem('phone'),
      'address1':widget.Address1.text,
      'address2':widget.Address2.text,
      'address3':widget.Address3.text,
      'address4':widget.Address4.text,
      'pincode':widget.pincode.text,
      'branch':storage.getItem('branch')});
    if ( response.statusCode == 200){
      setState(() {
        widget.Address1.text = '';
        widget.Address2.text = '';
        widget.Address3.text = '';
        widget.Address4.text = '';
        widget.pincode.text = '';
        _getCustomer = getCustomer();
      });
      
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
  Future AddressDialogBox()async{
    showDialog(context: context, builder: (context){
      return AlertDialog(content: Column(children: [
        Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Flatno/ apartment/floor',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                  controller: widget.Address1,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address1.text = value;  
                  //   });                  
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Street',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                  controller: widget.Address2
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address2.text = value;  
                  //   });                  
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Colony/City',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                  controller: widget.Address3,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address3.text = value;  
                  //   });                  
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'District/state',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                  controller: widget.Address4,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address4.text = value;  
                  //   });                  
                  // },
                ),
              ),   
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Pincode',border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                  controller: widget.pincode,
                  maxLength: 6,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address4.text = value;  
                  //   });                  
                  // },
                ),
              ),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address'))
      ],),);
    });
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
              children:snapshot.data['address1']== null?[
                Align(alignment: Alignment.centerLeft,child: Text('Address 1: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 1')),
                Align(alignment: Alignment.centerLeft,child: Text('Address 2: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 2'))
              ]: snapshot.data['address1']== null ?[
                 Align(alignment: Alignment.centerLeft,child: Text('Address 1: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 1')),
                Align(alignment: Alignment.centerLeft,child: Text('Address 2: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                Align(alignment: Alignment.centerLeft,child: Wrap(children:[ Text(snapshot.data['address2'].toString())])),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 2'))
              ]:snapshot.data['address2'] == null ? [
                Align(alignment: Alignment.centerLeft,child: Text('Address 1: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                Align(alignment: Alignment.centerLeft,child: Wrap(children:[ Text(snapshot.data['address1'].toString())])),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 1')),
                Align(alignment: Alignment.centerLeft,child: Text('Address 2: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                 ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 2'))
              ]:[                
                Align(alignment: Alignment.centerLeft,child: Text('Address 1: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                Align(alignment: Alignment.centerLeft,child: Wrap(children:[ Text(snapshot.data['address1'].toString())])),
                ElevatedButton(onPressed: ()=> updateAddress(widget.addressController.text.toString()), child: Text('Update or add address 1')),
                Align(alignment: Alignment.centerLeft,child: Text('Address 2: ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),)),
                Align(alignment: Alignment.centerLeft,child: Wrap(children:[ Text(snapshot.data['address2'].toString())])),
                ElevatedButton(onPressed: ()=> {updateAddress(widget.addressController.text.toString())}, child: Text('Update or add address 2'))
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