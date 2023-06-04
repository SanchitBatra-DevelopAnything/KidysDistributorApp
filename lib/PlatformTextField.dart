import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const PlatformTextField(
      {Key? key, required this.labelText, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoTextField(
            placeholder: labelText,
            controller: controller,
            autocorrect: false,
            showCursor: true,
            cursorColor: CupertinoColors.activeGreen,
            prefix: CupertinoButton(
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.black54,
              ),
              onPressed: () {},
            ),
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              border: Border.all(
                color: CupertinoColors.lightBackgroundGray,
                width: 2,
              ),
            ),
          )
        : TextFormField(
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                label: Text(labelText),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: CupertinoColors.lightBackgroundGray)),
                prefixIcon:
                    Icon(Icons.person_outline_rounded, color: Colors.black54),
                labelStyle: TextStyle(color: Colors.black54),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0XFFdd0e1c)),
                )),
            controller: controller,
          );
  }
}
