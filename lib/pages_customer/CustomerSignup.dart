import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_Operators/login.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool obsureText2 = true;
  SignUppage();

  @override
  State<SignUppage> createState() => _SignUppagestate();
}

class _SignUppagestate extends State<SignUppage> {
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
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
              builder: (context) => CustomerLoginpage()),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Aldready account With this number is there'),backgroundColor: Colors.green,));
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
    var body = {
      'phone': widget.phone.phoneNumber.toString(),
      'type':'signup'
    };
    final url = Uri.parse(main.url_start + 'mobileApp/sendotp/');

    final response = await http.post(url, body: body);
    if (response.statusCode == 200){
      var data = json.decode(response.body) as Map;
      var otp = data['otp'];
      print(otp);
      otpDialogBox(context).then((value){
        print('by user'+otpbyuser.toString());
        if (otp.toString() == otpbyuser){
          print(widget.verifyed);
        setState(() {
          widget.verifyed = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Otp dont match retry'),backgroundColor: Colors.red,));
      }
      });
    }else if (response.statusCode == 111){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User with this phone number is aldready there'),backgroundColor: Colors.red,));
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
                child: widget.verifyed== true? Column(children: 
                  [Text('Register', style: TextStyle(fontSize: 40, fontFamily: GoogleFonts.robotoMono().fontFamily,color: Colors.white)),
                Column(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [Form(
                            key: _formkey,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.NameController,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Full Name',
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
                          ),
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Name should be there';
                                        }
                                        return null;
                                      },
                                    ),
                              ), 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.EmailController,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
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
                          ),
                            validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email should be there';
                                        }else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)==false){
                                          return 'Email pattern is wrong';
                                        }
                                        
                                        return null;
                                      },
                                    ),
                              ), 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.usernameController,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Username',
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
                          ),
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'User name should be there';
                                        }
                                        return null;
                                      },
                                    ),
                              ), 
                          
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.passwordController,
                                    obscureText: widget.obsureText,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
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
                                ),
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
                          ),
                                  validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password should is compulsary';
                                        }
                                        return null;
                                      },
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.confirmPasswordController,
                                    obscureText: widget.obsureText2,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            suffixIcon: IconButton(
                                  icon: widget.obsureText2
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.security_sharp),
                                  onPressed: () {
                                    setState(() {
                                      widget.obsureText2 = !widget.obsureText2;
                                    });
                                  },
                                ),
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
                          ),
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
                              ),                
                             
                            ]),
                          ),
                           FlatButton(onPressed: (){Navigator.pushReplacement(context, CustomPageRoute(child: Loginpage()));}, child: Text('Aldready have an account?',style: TextStyle(color: Color.fromARGB(255, 207, 206, 206), decoration: TextDecoration.underline),)),
                           ElevatedButton(
                              
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
                      )),
                    ),
                  ],
                )
              ]):
              Column(
                children: [
                  Text('Register', style: TextStyle(fontSize: 40, fontFamily: GoogleFonts.robotoMono().fontFamily,color: Colors.white)),
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
                            FlatButton(onPressed: (){Navigator.pushReplacement(context, CustomPageRoute(child: CustomerLoginpage()));}, child: Text('Aldready have an account? ',style: TextStyle(color: Color.fromARGB(255, 207, 206, 206), decoration: TextDecoration.underline),)),
                            ElevatedButton(onPressed: (){if (_formkey2.currentState.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data') , backgroundColor: Colors.green,),);
                                receiveOtp(context);
                                  }
                                }, child: Text('Receive Otp')),
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

