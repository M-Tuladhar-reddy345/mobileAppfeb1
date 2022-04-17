import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/pages_customer/CustomerSignup.dart';
import '../main.dart' as main;
import '../widgets/Pageroute.dart';
import 'package:provider/provider.dart';
import '../models.dart' as models;
import '../widgets/navbar.dart' as navbar;
import 'home.dart' as home;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class Loginpage extends StatefulWidget {
  String message;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String branch = '';
  bool obsureText = true;

  Loginpage();

  @override
  State<Loginpage> createState() => _Loginpagestate();
}

class _Loginpagestate extends State<Loginpage> {
  submit() async {
    final body = {
      'username': widget.usernameController.text,
      'password': widget.passwordController.text,
      'branch': widget.branch,
    };
    print(body);
    final url = Uri.parse(main.url_start + 'mobileApp/login/');

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
      if (data['message'] == 'Success') {
        print(data);

        main.storage.setItem('username', data['name']);
        // print(main.storage.getItem('username'));
        main.storage.setItem('branch', data['branch']);
        main.storage.setItem('role', data['role']);
        main.storage.setItem('ttl', '0.0');
        main.storage.setItem('products', '0');
        main.storage.setItem('cart', {});
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
              child: Column(children: 
                [Text('Staff Login', style: TextStyle(fontSize: 40, fontFamily: GoogleFonts.robotoMono().fontFamily,color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
                      child: Padding(
                    padding: const EdgeInsets.all(0.8),
                    child: Column(
                      
                      children: [
                      
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
                        ),
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
                      // FutureBuilder(
                      //     future: get_branch(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.data == null) {
                      //         return Container(
                      //           child: Text('loading'),
                      //         );
                      //       } else
                      //         return Container(
                      //           child: DropdownButton(
                      //             isExpanded: true,
                      //             value: widget.branch,
                      FlatButton(onPressed: (){Navigator.pushReplacement(context, CustomPageRoute(child: SignUppage()));}, child: Text('No Account? Create One',style: TextStyle(color: Color.fromARGB(255, 207, 206, 206), decoration: TextDecoration.underline),)),
                      //             // icon: const Icon(Icons.arrow_downward),
                      //             elevation: 16,
                      //             style: const TextStyle(color: Colors.deepPurple),
                      //             underline: Container(
                      //               height: 2,
                      //               width: 300,
                      //               color: Colors.deepPurpleAccent,
                      //             ),
                      //             onChanged: (newValue) {
                      //               setState(() {
                      //                 widget.branch = newValue;
                      //               });
                      //             },
                      //             items: snapshot.data
                      //                 .map<DropdownMenuItem<String>>((v) {
                      //               return DropdownMenuItem<String>(
                      //                   value: v.code.toString(),
                      //                   child: Text(v.branch.toString() +
                      //                       '-' +
                      //                       v.address.toString()));
                      //             }).toList(),
                      //           ),
                      //         );
                      //     }),
                      ElevatedButton(
                        
                        onPressed: () => submit(),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      ElevatedButton(onPressed: (){ 
                                Navigator.pushReplacement(context, CustomPageRoute(child: CustomerLoginpage()));
                              }, child: Text('Customer Login')),
                    ]),
                  )),
                )
              ]),
            ),
          ),
        ));
  }
}

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {

//   AnimationController _animationController;
  
//   @override
//   void initState() {
//      super.initState();
//     _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
//     _animationController.addListener((){
// 		  setState((){});
// 	  });
//     _animationController.forward();
//   }
  
//   @override
//   void dispose() {
//      super.dispose();
//     _animationController.dispose();
//   } 
// }