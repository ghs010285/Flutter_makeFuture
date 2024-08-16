import 'package:flutter/material.dart';

class HaveLetterDataView extends StatelessWidget {
  const HaveLetterDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: const Text("편지쓰기"),
      ),
      body: const Center(
        child: Text("오늘은 내일의 편지를 작성했어요!\n내일의 연인이 편지를 확인할겁니다!"),
      ),
    );
  }
}
