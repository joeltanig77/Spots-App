import 'package:flutter/material.dart';

const textInputStyle = InputDecoration(
  border: OutlineInputBorder(),
  labelText: "Email",
);

const cardStyleForSettings = Card(
  elevation: 0,
  margin: EdgeInsets.all(6.0),
  color: Colors.white,
  child: ListTile(
    title: Text("About"),
    trailing: Icon(Icons.read_more),
  ),
);

Widget settingsCard(String text, dynamic function) {
  return Card(
    elevation: 0,
    margin: EdgeInsets.all(8),
    color: Colors.white,
    child: ListTile(
      title: Text(text),
      onTap: () {
        print("Button in settings clicked");
        print(function.toString());
        function;
      },
    ),
  );
}
