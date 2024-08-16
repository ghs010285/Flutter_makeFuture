import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  signUpState createState() => signUpState();
}

class signUpState extends State<SignUp> {

  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText1 = TextEditingController();
  final TextEditingController passwordText2 = TextEditingController();
  final TextEditingController name = TextEditingController();

  Future<void> _signup() async{
    print("SIGNUP START");
    final auth = FirebaseAuth.instance;
    if(emailText.text.isEmpty) {
      setState(() {
        print("EAMIL!");
      });
    } else if(name.text.isEmpty) {
      print("NAME!");
    } else if(passwordText1.text != passwordText2.text) {
      print("PASSWORD!");
    } else {
      await Firebase.initializeApp();
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: emailText.text, password: passwordText1.text);
        User? user = userCredential.user;
        final db = FirebaseFirestore.instance;
        await db.collection('users').doc(emailText.text).set({
          'email' : emailText.text,
          'uid' : user!.uid,
          'userName' : name.text,
        });
      } catch (e) {
        print('ERROR : $e');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size.width;
    // double screenWidth = screenSize > 600 ? 20.0 : 40.0;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: emailText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 200, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 0, color: Colors.grey)),
                      hintText: '이메일'),
                ),
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 200, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 0, color: Colors.grey)),
                      hintText: '이름'),
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordText1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 200, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 0, color: Colors.grey)),
                      hintText: '비밀번호'),
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordText2,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 200, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                              width: 0, color: Colors.grey)),
                      hintText: '비밀번호 확인'),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontFamily: "noto-sans",
                            fontWeight: FontWeight.w400)),
                    onPressed: () => _signup(),
                    child: const Text('다음')
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // return MaterialApp(
    //     home: SafeArea(
    //   child: Scaffold(
    //       appBar: AppBar(
    //           backgroundColor: Colors.white,
    //           leading: IconButton(
    //               icon: const Icon(Icons.arrow_back_ios_new),
    //               onPressed: _goToBackPage)),
    //       body: SingleChildScrollView(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             SizedBox(
    //               width: MediaQuery.of(context).size.width,
    //               height: MediaQuery.of(context).size.height - 160,
    //               child: PageView(
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 padEnds: false,
    //                 onPageChanged: (index) {
    //                   if (index == 0 || index == 1) {
    //                     _clearText();
    //                   }
    //                 },
    //                 controller: customController,
    //                 children: [
    //                   SizedBox.expand(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left: 10, right: 10),
    //                       child: Align(
    //                         alignment: Alignment.topLeft,
    //                         child: Container(
    //                           color: Colors.white,
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               SizedBox(
    //                                   width: MediaQuery.of(context).size.width,
    //                                   height: 100,
    //                                   child: const Align(
    //                                     alignment: Alignment.centerLeft,
    //                                     child: Text(
    //                                       "회원가입 약관 동의",
    //                                       style: TextStyle(
    //                                         fontFamily: "noto-snas",
    //                                         fontWeight: FontWeight.w900,
    //                                         fontSize: 35,
    //                                         color: Colors.black,
    //                                       ),
    //                                     ),
    //                                   )),
    //                               ..._renderCheckList(),
    //                               Align(
    //                                 alignment: Alignment.bottomLeft,
    //                                 child: Container(
    //                                   margin: const EdgeInsets.only(top: 10),
    //                                   child: Text(
    //                                     _checkBox,
    //                                     style: const TextStyle(
    //                                         fontFamily: 'noto-sans',
    //                                         fontWeight: FontWeight.w400,
    //                                         color: Colors.red),
    //                                   ),
    //                                 ),
    //                               ),
    //                               const Spacer(),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox.expand(
    //                     child: Container(
    //                       width: 400,
    //                       height: MediaQuery.of(context).size.height,
    //                       padding: EdgeInsets.all(screenWidth),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           TextFormField(
    //                             controller: emailText,
    //                             keyboardType: TextInputType.emailAddress,
    //                             decoration: InputDecoration(
    //                                 border: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 200, color: Colors.grey)),
    //                                 focusedBorder: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 0, color: Colors.grey)),
    //                                 hintText: '이메일'),
    //                           ), //이메일 인풋
    //                           TextFormField(
    //                             controller: name,
    //                             keyboardType: TextInputType.text,
    //                             decoration: InputDecoration(
    //                                 border: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 200, color: Colors.grey)),
    //                                 focusedBorder: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 0, color: Colors.grey)),
    //                                 hintText: '이름'),
    //                           ), //이메일 인풋
    //                           TextFormField(
    //                             obscureText: true,
    //                             keyboardType: TextInputType.visiblePassword,
    //                             controller: passwordText1,
    //                             decoration: InputDecoration(
    //                                 border: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 200, color: Colors.grey)),
    //                                 focusedBorder: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 0, color: Colors.grey)),
    //                                 hintText: '비밀번호'),
    //                           ), //비밀번호 인풋
    //                           TextFormField(
    //                             obscureText: true,
    //                             keyboardType: TextInputType.visiblePassword,
    //                             controller: passwordText2,
    //                             decoration: InputDecoration(
    //                                 border: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 200, color: Colors.grey)),
    //                                 focusedBorder: OutlineInputBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(0.0),
    //                                     borderSide: const BorderSide(
    //                                         width: 0, color: Colors.grey)),
    //                                 hintText: '비밀번호 확인'),
    //                           ), //비밀번호 인풋
    //                           Container(
    //                             alignment: Alignment.centerLeft,
    //                             margin: const EdgeInsets.only(top: 10),
    //                             child: Text(
    //                               _checkInputText,
    //                               style: const TextStyle(
    //                                   fontFamily: 'noto-sans',
    //                                   fontWeight: FontWeight.w400,
    //                                   color: Colors.red),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox.expand(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left: 10, right: 10),
    //                       child: Align(
    //                         alignment: Alignment.center,
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                           children: [
    //                             Text(
    //                               "환영해요!\n$_showUserName님",
    //                               style: const TextStyle(
    //                                   fontSize: 55,
    //                                   fontFamily: "noto-snas",
    //                                   fontWeight: FontWeight.w900,
    //                                   color: Colors.black),
    //                             ),
    //                             const Text(
    //                               "마지막으로 이메일 인증을 완료 해 주시면 됩니다."
    //                               "\n아래의 버튼을 누르면, 로그인 화면으로 이동합니다.",
    //                               style: TextStyle(
    //                                   fontSize: 15,
    //                                   fontFamily: "noto-snas",
    //                                   fontWeight: FontWeight.w500,
    //                                   color: Colors.black),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             _buildButton(),
    //           ],
    //         ),
    //       )),
    // ));
  }
}