import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makefuture/fragment/letter.dart';
import 'package:makefuture/fragment/letterBox.dart';
import 'package:makefuture/fragment/more.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.user});
  final User user;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var _fragmentIndex = 0;
  final List _fragment = [
    Letter(),
    LetterBox(),
    More()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: _fragment[_fragmentIndex],
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _fragmentIndex,
              onTap: (value) {
                setState(() {
                  _fragmentIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: "Letter",
                    activeIcon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shower_outlined),
                    label: "LetterBox",
                    activeIcon: Icon(Icons.shower)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz_outlined),
                    label: "More",
                    activeIcon: Icon(Icons.more_horiz)),
              ],
            ),
          ),
        )
    );
  }
}