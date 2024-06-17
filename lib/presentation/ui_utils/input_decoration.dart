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
    hintText: 'Gender',
    border: InputBorder.none,
    hintStyle: TextStyle(color: Colors.black),
    focusedBorder: InputBorder.none,
    focusColor: Colors.grey,
  );

  // Add other input decorations as needed
}
