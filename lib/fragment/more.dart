import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class More extends StatefulWidget {
  More({super.key});

  @override
  MoreState createState() => MoreState();
}

class MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Text("More"),
        ),
      ),
    );
  }
}