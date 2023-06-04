import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kidys_distributor/termsAndConditions.dart';
import 'package:path_provider/path_provider.dart';

class BottomSheetModal extends StatefulWidget {
  @override
  _BottomSheetModalState createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  bool termsAccepted = false;
  String pathPDF = "";

  @override
  void initState() {
    // TODO: implement initState
    fromAsset('assets/tnc.pdf', 'tnc.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    super.initState();
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

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
                          if (pathPDF.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndConditionsPage(path: pathPDF),
                              ),
                            );
                          }
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
                          if (termsAccepted) {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/login');
                          }
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
