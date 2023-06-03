import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6E3D3),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: CupertinoButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DOWNLOAD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(
                CupertinoIcons.arrow_down_circle_fill,
                color: CupertinoColors.white,
              ),
            ],
          ),
          onPressed: () {},
          color: Color(0xffdd0e1c),
        )),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: Text('TERMS AND CONDITIONS'),
        backgroundColor: Color(0xffE6E3D3),
      );
    } else {
      return AppBar(
        title: Text('TERMS AND CONDITIONS'),
      );
    }
  }
}
