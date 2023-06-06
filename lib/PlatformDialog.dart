import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDialog extends StatelessWidget {
  final String title;
  final String content;
  const PlatformDialog({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: CupertinoButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              CupertinoDialogAction(
                child: CupertinoButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        : AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Color(0xffdd0e1c)),
                  child: Text("OK",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Color(0xffdd0e1c)),
                  child: Text("CANCEL",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)))
            ],
          );
  }
}
