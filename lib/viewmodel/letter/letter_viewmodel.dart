import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

class LetterViewModel extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  String? documentId;
  String? myUid;
  String? currentDate;
  String? dbUrl;
  String? checkMessage = '';
  File? image;
  DocumentReference? docRef;
  bool isLoading = false;
  String letterText = '';
  String letterTitle = '';

  LetterViewModel() {
    myUid = auth.currentUser!.uid;
    DateTime nowDateTime = DateTime.now();
    DateTime newFutureDate = nowDateTime.add(Duration(days: 1));
    currentDate = DateFormat('yyyy-MM-dd').format(newFutureDate);
    print(currentDate);
    _checkCollectionName();
  }
  Future<void> _checkCollectionName() async {
    QuerySnapshot snapshot = await db.collection('couple').get();
    for(var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if(data['couple1'] == myUid || data['couple2'] == myUid) {
        documentId = doc.id;
        docRef = db.collection('couple').doc(documentId).collection('LetterBoxDate').doc(currentDate);
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> checkLetterContext(BuildContext context) async {
    notifyListeners();

    if(letterText.isEmpty) {
      checkMessage = "편지 내용을 입력 해 주세요.";
      showSnackBar(context, checkMessage!);
    } else if(image == null) {
      checkMessage = "사진을 찍어서 업로드 해 주세요";
      showSnackBar(context, checkMessage!);
    } else {
      await Firebase.initializeApp();
      try {
        Reference storage = FirebaseStorage.instance.ref().child('image/${Path.basename(image!.path)}');
        UploadTask uploadTask = storage.putFile(image!);
        TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await storageSnapshot.ref.getDownloadURL();
        Timestamp currentTime = Timestamp.now();

        await db.collection('couple').doc(documentId).collection('LetterBoxDate').doc(currentDate).collection(myUid!).doc(myUid).set({
          'imgUrl': imageUrl,
          'letterText': letterText,
          'letterTitle' : letterTitle,
          'uid' : myUid,
          'music': null,
          'time': currentTime
        });
      } catch (e) {
      //
      }
    }
    notifyListeners();
    isLoading = false;
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: '확인',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}