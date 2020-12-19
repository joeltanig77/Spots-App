import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = "";
  String password = "";
  final Service _auth = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0, //Take off the drop shadow
        title: Text("Register to Spots"),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign In"),
            onPressed: () {
                widget.toggleView();
            },
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val.trim();
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    password = val.trim();
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              RaisedButton.icon(
                icon: Icon(Icons.app_registration),
                label: Text(
                  "Register Account",
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: () async {
                  print(email);
                  print(password);
                },
                color: Colors.purple[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}
