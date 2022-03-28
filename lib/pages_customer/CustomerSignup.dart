import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_common/login.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../models.dart' as models;
import '../widgets/navbar.dart' as navbar;
import '../pages_Operators/home.dart' as home;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class SignUppage extends StatefulWidget {
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

  SignUppage();

  @override
  State<SignUppage> createState() => _SignUppagestate();
}

class _SignUppagestate extends State<SignUppage> {
  final _formkey = GlobalKey<FormState>();
  submit() async {  
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
          .map<models.Branch>((json) => models.Branch.fromjson(json))
          .toList();

      return Branches;
    }
  }
  String phoneNumber, verificationId;
  String otpbyuser;
  Future receiveOtp(BuildContext context) async{
    var otp = Random().nextInt(999999)+ 100000;
    print(otp);
    otpDialogBox(context).then((value){
      print('by user'+otpbyuser.toString());
      print(otp);
      if (otp.toString() == otpbyuser){
        print(widget.verifyed);
      setState(() {
        widget.verifyed = true;
      });
    }
    });
    

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
        appBar: AppBar(
          title: Text('SignUp'),
        ),
        body: SingleChildScrollView(
            child: widget.verifyed== true? Column(children: [
            Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [Form(
                  key: _formkey,
                  child: Column(children: [
                    TextFormField(
                        controller: widget.NameController,
                        decoration: InputDecoration(labelText: 'Full Name'),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name should be there';
                            }
                            return null;
                          },
                        ), 
                    TextFormField(
                        controller: widget.EmailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email should be there';
                            }
                            return null;
                          },
                        ), 
                    TextFormField(
                        controller: widget.usernameController,
                        decoration: InputDecoration(labelText: 'User Name'),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'User name should be there';
                            }
                            return null;
                          },
                        ), 
                
                    TextFormField(
                        controller: widget.passwordController,
                        obscureText: widget.obsureText,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: widget.obsureText
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.security_sharp),
                              onPressed: () {
                                setState(() {
                                  widget.obsureText = !widget.obsureText;
                                });
                              },
                            )),
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password should is compulsary';
                            }
                            return null;
                          },
                        ),
                    TextFormField(
                        controller: widget.confirmPasswordController,
                        obscureText: widget.obsureText,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: widget.obsureText
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.security_sharp),
                              onPressed: () {
                                setState(() {
                                  widget.obsureText = !widget.obsureText;
                                });
                              },
                              
                            )),
                      // ignore: missing_return
                      validator: (value) {
                            if (widget.passwordController.text ==null){
                              return 'Password is needed before to confirm it';
                            }
                            else if (value == null || value.isEmpty ) {
                              return 'Password should is compulsary';
                            }else if(widget.passwordController.text != value){
                              return 'Password didnt match';
                            }
                            return null;
                          },
                      ),                
                   
                  ]),
                ),
                 FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                    if (_formkey.currentState.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data') , backgroundColor: Colors.green,),);
                    submit();
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]
              ),
            ))
          ]):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InternationalPhoneNumberInput(
                  countries: ['IN'],
                  onInputChanged: (PhoneNumber number) {
                  setState(() {
                    widget.phone = number;
                  });
                },
                onInputValidated: (bool value) {
                  print(value);
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
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },),
                ElevatedButton(onPressed: () => receiveOtp(context), child: Text('Receive Otp')),
              ],

            ),
          )

        ));
  }
}

