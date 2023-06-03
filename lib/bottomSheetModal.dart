import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomSheetModal extends StatefulWidget {
  @override
  _BottomSheetModalState createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffE6E3D3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'TERMS AND CONDITIONS',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Radio(
                value: true,
                activeColor: Color(0xffdd0e1c),
                groupValue: termsAccepted,
                onChanged: (value) {
                  setState(() {
                    termsAccepted = value as bool;
                  });
                },
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'I have read and agree to the ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'terms and conditions',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to a different page with the terms and conditions
                          // You can use Navigator.push() to navigate to a new page
                        },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Color(0xffdd0e1c)),
                  ),
                  onPressed: termsAccepted
                      ? () {
                          // Handle accept button press
                        }
                      : null,
                ),
                CupertinoButton(
                  child: Text(
                    'Exit',
                    style: TextStyle(color: Color(0xffdd0e1c)),
                  ),
                  onPressed: () {
                    // Handle exit button press
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
