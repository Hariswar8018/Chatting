import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Image.asset("assets/33bfe9ad-805b-405f-90f1-584e3c2f5fc6.jpeg",width: w,),
        ],
      ),
    );
  }
}
