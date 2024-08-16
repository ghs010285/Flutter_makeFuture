import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makefuture/coupleCode.dart';
import 'package:makefuture/firebase_options.dart';
import 'package:makefuture/login.dart';
import 'package:makefuture/mainPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  checkState createState() => checkState();
}

class checkState extends State<MainScreen> {
  bool isUidAbsent = false;
  final auth = FirebaseAuth.instance;

  Future<void> _checkUser() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('couple').get();
    bool checkingUid = false;
    String? myUid = auth.currentUser!.uid;

    for(var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if(data['couple1'] == myUid || data['couple2' == myUid]) {
        checkingUid = true;
        break;
      } else {
        checkingUid == false;
        break;
      }
    }
    if(!checkingUid) {
      setState(() {
        isUidAbsent = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return isUidAbsent ? const CoupleCodeView() : checkUserState();
  }
}

class checkUserState extends StatelessWidget {
  const checkUserState({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User? user = snapshot.data;
                    if (user == null) {
                      return const Login();
                    }
                    return MainPage(user: user);
                  }
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                })));
  }
}