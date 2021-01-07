import 'package:flutter/material.dart';
import '';
/*
const textInputStyleex = InputDecoration(
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
*/

const textInputStyle =  InputDecoration(
  border: OutlineInputBorder(
  ),
  labelText: "Email",
);


const cardStyleForSettings = Card(
  elevation: 0,
  margin: EdgeInsets.all(6.0),
  color: Colors.white,
  child: ListTile(
    title: Text("About"),
    trailing: Icon(
        Icons.read_more
    ),
  ),
);

Widget settingsCard(String text, dynamic function){
  return Card(
      elevation: 0,
      margin: EdgeInsets.all(8),
      color: Colors.white,
      child: ListTile(
      title: Text(text),
      onTap: () {
        print("Button in settings clicked");
        function;
  },
  ),
  );
  }