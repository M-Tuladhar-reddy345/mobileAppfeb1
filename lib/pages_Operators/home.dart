import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/pages_customer/addingtoCart.dart';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';


class Homepage extends StatefulWidget {
  String message;

  Homepage();

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List homeImages = [
    'bg_11.jpeg',
    'bg_12.jpeg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
             ImageSlideshow(
          width: double.infinity ,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {
            debugPrint('Page changed: $value');
          },
          autoPlayInterval: 3000,
          isLoop: true,
          children: homeImages.map((e) {
            return Image(image: AssetImage('assets/images/$e'));
          }).toList()
        ),
        Center(child: ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddingToCartpage()));
        }, child: Text('Place order')),)
          ]),
        ));
  }
}

