import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makefuture/signUp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController emailText = TextEditingController();
  final TextEditingController passwordText = TextEditingController();

  String _checkInputText = '';
  // ignore: non_constant_identifier_names
  Future<void> MovePage(context) async {
    final auth = FirebaseAuth.instance;

    if (emailText.text.isEmpty) {
      setState(() {
        _checkInputText = '이메일을 입력 해 주세요.';
      });
    } else if (passwordText.text.isEmpty) {
      setState(() {
        _checkInputText = '비밀번호를 입력 해 주세요.';
      });
    } else {
      await Firebase.initializeApp();
      try {
        final UserCredential userCredential =
        await auth.signInWithEmailAndPassword(
            email: emailText.text, password: passwordText.text);
        if (userCredential.user != null) {
          if (!userCredential.user!.emailVerified) {
            setState(() {
              _checkInputText = '이메일 인증을 완료 해 주세요.';
            });
          } else {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => MainPage(user: userCredential.user!)));
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _checkInputText = e.email ?? '아이디 혹은 비밀번호가 잘못되었습니다.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;
    double screenWidth = screenSize > 600 ? 20.0 : 40.0;

    return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 400,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(screenWidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 550,
                        height: 150,
                        margin: const EdgeInsets.only(bottom: 50),
                        child: Image.asset('assets/veno_black.png'),
                      ), //로고 이미지
                      TextFormField(
                        controller: emailText,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: const BorderSide(
                                    width: 200, color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide:
                                const BorderSide(width: 0, color: Colors.grey)),
                            hintText: '아이디'),
                      ), //이메일 인풋
                      TextFormField(
                        controller: passwordText,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide:
                              const BorderSide(width: 200, color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide:
                                const BorderSide(width: 0, color: Colors.grey)),
                            hintText: '비밀번호'),
                      ), //비밀번호 인풋
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          _checkInputText,
                          style: const TextStyle(
                              fontFamily: 'noto-sans',
                              fontWeight: FontWeight.w400,
                              color: Colors.red),
                        ),
                      ), //경고글자
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 10000,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: "noto-sans",
                                    fontWeight: FontWeight.w400)),
                            onPressed: () => MovePage(context),
                            // onPressed: () => MovePage(context),
                            child: const Text(
                              '로그인',
                            )),
                      ), //로그인 버튼 섹션
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: const Text(
                                "회원가입",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "noto-sans",
                                    fontWeight: FontWeight.w500),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                              },
                            ),
                            const Text(
                              "계정찾기",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "noto-sans",
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 105,
                              margin: const EdgeInsets.only(top: 25),
                              child: const Divider(
                                  color: Colors.black12, thickness: 2.0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 25, left: 15, right: 15),
                              child: const Text(
                                style: TextStyle(color: Colors.black38),
                                '간편 로그인',
                              ),
                            ),
                            Container(
                              width: 105,
                              margin: const EdgeInsets.only(top: 25),
                              child: const Divider(
                                  color: Colors.black12, thickness: 2.0),
                            ),
                          ],
                        ),
                      ), //간편로그인 구분
                      Container(
                        width: 400,
                        height: 50,
                        margin: const EdgeInsets.only(top: 20),
                        child:
                        Image.asset('assets/kakao/kakao_login_large_wide.png'),
                      ), //카카오로그인
                      // Container(
                      //   width: 400,
                      //   height: 50,
                      //   margin: const EdgeInsets.only(top: 20),
                      //   child: SvgPicture.asset('assets/google/svg/web_light_sq_SU.svg'),
                      // ),     //카카오로그인
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}