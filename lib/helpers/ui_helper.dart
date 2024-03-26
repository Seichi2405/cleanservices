import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

// import 'package:paypal_integration_app/helpers/navigation_service.dart';
class UIHelper {
  static showAlertDialog(String message, {title = ''}) {
    OneContext().showDialog(builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0))),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'))
        ],
      );
    });
  }
}
