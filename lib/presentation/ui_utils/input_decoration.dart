import 'package:flutter/material.dart';

class InputDecorationManager {
  static const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
    borderSide: BorderSide(
      color: Colors.grey,
      style: BorderStyle.solid,
    ),
  );

  static const InputDecoration inputDecoration = InputDecoration(
    labelText: 'Gender',
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        color: Colors.red,
        style: BorderStyle.solid,
      ),
    ),
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: outlineInputBorder,
    focusColor: Colors.grey,
  );

  // Add other input decorations as needed
}
