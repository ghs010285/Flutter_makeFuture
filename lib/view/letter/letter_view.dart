import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/letter/letter_viewmodel.dart';

class LetterView extends StatelessWidget {
  const LetterView({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LetterViewModel(),
      child: Consumer<LetterViewModel>(
        builder: (context, model, child) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 4,
                title: const Text("편지쓰기"),
                actions: [
                  IconButton(
                      onPressed: () => model.checkLetterContext(context),
                      icon: const Icon(Icons.check))
                ],
              ),
              body: SingleChildScrollView(
                child: model.isLoading? const Center(child: CircularProgressIndicator())
                    : Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    children: [
                      Container(
                        height: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            model.image == null
                                ? const Text('No Image selected')
                                : ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8.0),
                              child: Image.file(
                                model.image!,
                                width: MediaQuery.of(context).size.width/2,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: 150,
                              height: 35,
                              margin: const EdgeInsets.only(top: 10, bottom: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: "noto-sans",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: model.pickImage,
                                child: const Text('사진 선택'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: TextFormField(
                          onChanged: (value) =>
                          model.letterTitle = value,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: '제목',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: TextFormField(
                          onChanged: (value) =>
                          model.letterText = value,
                          keyboardType: TextInputType.text,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: '편지를 작성 해 주세요.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          );
        },
      ),
    );
  }
}
