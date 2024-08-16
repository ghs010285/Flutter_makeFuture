import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makefuture/view/letter/haveLetterData_view.dart';
import 'package:makefuture/viewmodel/letter/letter_viewmodel.dart';
import 'package:provider/provider.dart';

import '../view/letter/letter_view.dart';

class Letter extends StatefulWidget {
  Letter({super.key});

  @override
  LetterState createState() => LetterState();
}

class LetterState extends State<Letter> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LetterViewModel(),
      child: Consumer<LetterViewModel>(builder: (context, model, child) {
        return Scaffold(
        body: StreamBuilder<DocumentSnapshot> (
          stream: model.docRef?.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasError) {
              return const Center(child: Text("ERROR"));
            } else if(!snapshot.hasData || !snapshot.data!.exists) {
              return const LetterView();
            } else {
              return const HaveLetterDataView();
            }
          }
        ),
        );
    }),
    );
  }
}