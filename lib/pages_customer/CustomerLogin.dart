import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_Operators/login.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerSignup.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../models.dart' ;
import '../widgets/navbar.dart' as navbar;
import '../pages_Operators/home.dart' as home;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerLoginpage extends StatefulWidget {
  String message;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final NameController = TextEditingController();
  final EmailController = TextEditingController();
  var phone = PhoneNumber();
  var PhoneNumberController = TextEditingController();
  var verifyed = false;
  String branch = '';
  bool obsureText = true;
  bool obsureText2 = true;
  CustomerLoginpage();

  @override
  State<CustomerLoginpage> createState() => _SignUppagestate();
}

class _SignUppagestate extends State<CustomerLoginpage> {
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  submit() async {
    final body = {
      'phone': widget.phone.phoneNumber.toString(),
      'password': widget.passwordController.text,
      'branch': widget.branch,
    };
    print(body);
    final url = Uri.parse(main.url_start + 'mobileApp/Customerrlogin/');

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
      if (data['message'] == 'Success') {
        print(data);
        main.storage.setItem('username', data['name']);
        main.storage.setItem('phone', data['phone']);
        // print(main.storage.getItem('username'));
        main.storage.setItem('branch', data['branch']);
        main.storage.setItem('role', data['role']);
        final body = {
      'phone': main.storage.getItem('phone')
    };
    final url = Uri.parse(main.url_start +
        'mobileApp/getCart/' );
    final response = await http.post(url, body: body);
    if (response.statusCode == 200){
      final data = json.decode(response.body) as Map;
      print(data);
      Map<String,Customerprod> cart = {};
      
      
      
      if (data['products'] == ''){
      main.storage.setItem('ttl', data['ttl']);
      main.storage.setItem('products', data['cartprods']);
      main.storage.setItem('cart',  <String,Customerprod> {} );}else{
        List products = data['products'] as List;
       for (var e in products){
        print(e);
        cart.putIfAbsent(e['pcode'], () => Customerprod(
                        e['pcode'].toString(),
                        e['ptype'].toString(),
                        e['unitRate'].toString(),
                        e['quantity'].toString(),
                        e['amount'].toString(),
                        e['pimage'].toString(),
                        e['pname'].toString()),);
      }
      print("@89");
      print(cart);
 main.storage.setItem('ttl', data['ttl']);
      main.storage.setItem('products', data['cartprods']);
      main.storage.setItem('cart',  cart);
      }
    }
        // print(main.storage.getItem('branch'));
        ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(data['message']), backgroundColor: Colors.green,));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => home.Homepage()),
        );
      } else {
        print(data);
        ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(data['message']),backgroundColor: Colors.red,));
      }
    }
  }
  submit2() async {  
    print(widget.phone);
    final body = {
      'full_name': widget.NameController.text,
      'email': widget.EmailController.text,
      'phone': widget.phone.phoneNumber.toString(),
      'username': widget.usernameController.text,
      'password1': widget.passwordController.text,
    };
    print(body);
    final url = Uri.parse(main.url_start + 'mobileApp/SignUp/');

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
      ScaffoldMessenger.of(context).clearSnackBars();
      if (data['message'] == 'Success') {
        print('success');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SuccessFully done'),backgroundColor: Colors.green,));
        // print(main.storage.getItem('branch'));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Loginpage()),
        );
      } else {
        print('fails');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message']),backgroundColor: Colors.green,));
      }
    }
  }

  get_branch() async {
    final url = Uri.parse(main.url_start + 'mobileApp/BranchDetails/');
    final response = await http.get(url);
    print(url);
    // print(response.statusCode);

    if (response.statusCode == 200) {
      //  print(response.body);
      var data = json.decode(response.body) as Map;
      //  print(data['results']);

      List Branches = data['results']
          .map<Branch>((json) => Branch.fromjson(json))
          .toList();

      return Branches;
    }
  }
  String phoneNumber, verificationId;
  String otpbyuser;
  Future receiveOtp(BuildContext context) async{
    var body = {
      'phone': widget.phone.phoneNumber.toString(),
      'type':'login'
    };
    final url = Uri.parse(main.url_start + 'mobileApp/sendotp/');

    final response = await http.post(url, body: body);
    print(response.statusCode);
    if (response.statusCode == 200){
      var data = json.decode(response.body) as Map;
      var otp = data['otp'];
      print(otp);
      otpDialogBox(context).then((value){
        print('by user'+otpbyuser.toString());
        if (otp.toString() == otpbyuser){
          main.storage.setItem('role', 'Customer');
          main.storage.setItem('branch', '');
          main.storage.setItem('username', '');
          main.storage.setItem('phone', widget.phone.phoneNumber.toString());
          Navigator.pushReplacement(context, CustomPageRoute(child: home.Homepage()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully logged in'),backgroundColor: Colors.green,));
      }else{
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Otp dont match'),backgroundColor: Colors.red,));
      }
      });
      
    } else if (response.statusCode == 111){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User with this phone number is not there'),backgroundColor: Colors.red,));
      }

  }
  otpDialogBox(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter your OTP'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otpbyuser = value;
                },
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                return otpbyuser;
              },
              child: Text(
                'Submit',
              ),
            ),
          ],
        );
      });
      }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor
          ), 
          child: Center(
            child: SingleChildScrollView(
                child: 
              Column(
                children: [
                  Text('Customer Login in', style: TextStyle(fontSize: 35, fontFamily: GoogleFonts.robotoMono().fontFamily,color: Colors.white)),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey2,
                        child: Column(
                          children: [
                            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InternationalPhoneNumberInput(
                                countries: ['IN'],
                                onInputChanged: (PhoneNumber number) {
                                setState(() {
                                  widget.phone = number;
                                });
                              },
                              
              
                              validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Phone number is important';
                                            }else if (RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value) == false){
                                              return 'Phone pattern not satisfied';
                                            }
                                            
                                            return null;
                                          },
                              
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: widget.phone,
                              textFieldController: widget.PhoneNumberController,
                              formatInput: false,
                              keyboardType:
                                  TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputBorder: OutlineInputBorder(),
                              inputDecoration: InputDecoration(filled: true,
                              fillColor: Colors.white,
                              hintText: 'Phone Number',
                              contentPadding:
                                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                              ),),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },),
                            ),
                            Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          
                            controller: widget.passwordController,
                            obscureText: widget.obsureText,
                            decoration: InputDecoration(border: OutlineInputBorder(),filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: widget.obsureText
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.security_sharp),
                                  onPressed: () {
                                    setState(() {
                                      widget.obsureText = !widget.obsureText;
                                    });
                                  },
                                ))),
                      ),
                            FlatButton(onPressed: (){Navigator.pushReplacement(context, CustomPageRoute(child: SignUppage()));}, child: Text('Dont have a account Click here to create one ',style: TextStyle(color: Color.fromARGB(255, 207, 206, 206), decoration: TextDecoration.underline),)),
                            // ElevatedButton(onPressed: (){if (_formkey2.currentState.validate()) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Processing Data') , backgroundColor: Colors.green,),);
                            //     receiveOtp(context);
                            //       }
                            //     }, child: Text('Receive Otp')),
                            ElevatedButton(
                        
                        onPressed: () => submit(),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                            ElevatedButton(onPressed: (){ 
                                  Navigator.pushReplacement(context, CustomPageRoute(child: Loginpage()));
                                }, child: Text('Staff Login')),
                          ],
                      
                        ),
                      ),
                    ),
                  ),
                ),]
              )

            ),
          ),
        ));
  }
}

