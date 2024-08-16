import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LetterActivityView extends StatelessWidget {
  final String imgUrl;
  final String letterText;
  final String timeStamp;
  final String title;

  const LetterActivityView({
    Key? key,
    required this.imgUrl,
    required this.letterText,
    required this.timeStamp,
    required this.title
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편지내용'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(imgUrl.isNotEmpty)
              Image.network(imgUrl),
            const SizedBox(height: 16),
            Text(
                'Title: $title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              letterText,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}