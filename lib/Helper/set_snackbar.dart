import 'package:flutter/material.dart';

setSnackbar(String msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      duration: const Duration(
        seconds: 4,
      ),
      backgroundColor: Colors.white,
      elevation: 1.0,
    ),
  );
}
