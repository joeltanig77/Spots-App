import 'package:flutter/material.dart';

const textInputStyle = InputDecoration(
    hintText: "Email",
    fillColor: Colors.white,
    // Anytime you do a fill color make sure that filled = true
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.white,
            width: 2.0
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0
        )
    )
);