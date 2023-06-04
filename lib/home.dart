import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottomSheetModal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheetModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // ignore: prefer_const_literals_to_create_immutables
          gradient: LinearGradient(
              colors: [Color(0xffE6E3D3), Color(0xffE6E3D3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 250,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 16,
            ),
            CupertinoButton(
              onPressed: () {
                _showBottomSheet(context);
              },
              color: Color(0xffdd0e1c),
              child: Text(
                "LOGIN",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              color: Color(0xffdd0e1c),
              child: Text(
                "SIGN UP",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
