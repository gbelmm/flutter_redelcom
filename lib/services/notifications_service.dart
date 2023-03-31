import 'package:flutter/material.dart';

class NotificationsService {
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 300.0),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
