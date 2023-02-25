import 'package:flutter/material.dart';

void showMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 15,
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

