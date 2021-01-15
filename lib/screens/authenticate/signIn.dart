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

    final bgColor  = Color(0xffEFE2C8);
    final barColor = Color(0xFF4a6299);
    final gColor1  = Color(0xffd8a156);


    return areWeLoading ? LoadingAnimation() : Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: barColor,
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
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('images/spots_logo1.png'),
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
                      decoration: textInputStyle.copyWith(labelText: 'Password')
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
                    color: barColor,
                  ),
                  SizedBox(height: 14.0,),
                  //TODO: UI team please make my ui/button better lol just keep the function nav I have

                  SizedBox(height: 20.0,),
                  Text(error,
                    style: TextStyle(
                      color: Colors.red[311],
                      fontSize: 15,
                    ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
