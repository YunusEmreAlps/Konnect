
import 'package:flutter/material.dart';

const Color primaryColor = Color(0XFF00C9B1);

const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'Type your message here...',
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ));




