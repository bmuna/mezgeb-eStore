import 'package:flutter/material.dart';

const KTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0))),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.8,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          3.0,
        ),
      ),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xff38D39F), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(3.0))));
