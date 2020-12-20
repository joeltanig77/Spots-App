import 'package:flutter/material.dart';
import 'package:spots_app/const/loading.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/const/sharedStyles.dart';
class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String error = '';
  String email = "";
  String password = "";
  final Service _auth = Service();
  final _formKey = GlobalKey<FormState>();
  bool areWeLoading = false;

  @override
  Widget build(BuildContext context) {
    return areWeLoading ? LoadingAnimation() : Scaffold(
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
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val.trim();
                  });
                },
                decoration: textInputStyle
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter a password' : null,
                onChanged: (val) {
                  setState(() {
                    password = val.trim();
                  });
                },
                obscureText: true,
                  decoration: textInputStyle.copyWith(hintText: "Password"),
              ),
              SizedBox(height: 20),
              RaisedButton.icon(
                icon: Icon(Icons.login),
                label: Text(
                  "Log In",
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      areWeLoading = true;
                    });
                    // Futures always await
                    dynamic resultFromSignIn = await _auth.signInAccount(email, password);
                    if(resultFromSignIn == null){
                      setState(() {
                        error = "Incorrect credentials, please try again";
                        areWeLoading = false;
                      });
                    }
                  }
                },
                color: Colors.purple[300],
              ),
              SizedBox(height: 14.0,),
              Text(error,
                style: TextStyle(
                  color: Colors.red[311],
                  fontSize: 15,
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
