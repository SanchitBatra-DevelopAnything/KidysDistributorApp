import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Loading offers for you....',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              CupertinoButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context , '/');
                                },
                                color: Colors.black,
                                child: Text(
                                  "Go Back to Home Page.",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
