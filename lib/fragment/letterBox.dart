import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makefuture/view/letterBox/letterBox_view.dart';

class LetterBox extends StatefulWidget {
  LetterBox({super.key});

  @override
  LetterBoxState createState() => LetterBoxState();
}

class LetterBoxState extends State<LetterBox> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: LetterBoxView(),
        ),
      ),
    );
  }
}