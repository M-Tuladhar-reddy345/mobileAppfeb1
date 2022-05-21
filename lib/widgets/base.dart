import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';

import '../widgets/navbar.dart' as navbar;
class Base extends StatefulWidget {

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('base', Size(MediaQuery.of(context).size.width,56)),
      body: Container(),
    );
  }
}