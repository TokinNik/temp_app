import 'package:flutter/material.dart';

class TestPage2 extends Page {
  final Function()? onTap;

  TestPage2({this.onTap});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => TestScreen2(onTap: onTap),
    );
  }
}

class TestScreen2 extends StatefulWidget {

  const TestScreen2({Key? key, this.onTap}) : super(key: key);
  final Function()? onTap;

  @override
  State<TestScreen2> createState() => _TestScreen2State();
}

class _TestScreen2State extends State<TestScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page 2"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: widget.onTap ?? () {
                },
                child: Text("back to test_1"),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text("qqq"),
            ),
          ),
        ],
      ),
    );
  }
}
