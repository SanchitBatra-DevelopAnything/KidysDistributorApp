import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationProvider with ChangeNotifier {
  Future<void> getDeviceTokenToSendNotification(name, area, platform) async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    var deviceTokenToSendPushNotification = token.toString();

    if (platform == "Apple") {
      name = name + "-APPLE";
    } else {
      name = name + "-Android";
    }

    var url = Uri.parse(
        'https://kidysadminapp-default-rtdb.firebaseio.com/notificationTokens/' +
            area +
            "/" +
            name +
            ".json");
    try {
      await http.patch(url,
          body: json.encode({"token": deviceTokenToSendPushNotification}));
      notifyListeners();
    } catch (error) {
      print("UNABLE TO PATCH NOTIFICATION TOKEN");
      print(error);
    }
  }
}
