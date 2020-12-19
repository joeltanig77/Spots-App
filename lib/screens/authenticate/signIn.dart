import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "";
  String password = "";
  final Service _auth = Service();

  @override
  Widget build(BuildContext context) {
    // We do a Scafford so we can add a app bar and stuff
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0, //Take off the drop shadow
        title: Text("Sign in to Spots"),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Register"),
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
                icon: Icon(Icons.login),
                label: Text(
                    "Sign In",
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
