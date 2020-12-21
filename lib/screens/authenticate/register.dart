import 'package:flutter/material.dart';
import 'package:spots_app/const/loading.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/const/sharedStyles.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String error = '';
  String email = "";
  String password = "";
  final Service _auth = Service();
  final _formKey = GlobalKey<FormState>();
  bool areWeLoading = false;

  @override
  Widget build(BuildContext context) {
    return areWeLoading ? LoadingAnimation() : Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
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
          key: _formKey,
          child: Column(
            children: [
              Image.asset('images/signupplaceholder.png'),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val.trim();
                  });
                },
                decoration: textInputStyle,
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (val) => val.length < 8 ? 'Enter a password with more than 8+ chars long' : null,
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
                icon: Icon(Icons.app_registration),
                label: Text(
                  "Register Account",
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      areWeLoading = true;
                    });
                    dynamic resultOfAccountCreation = await _auth.registerAccount(email, password);
                    if(resultOfAccountCreation == null) {
                      setState(() {
                        error = 'This is not a legal email address, please try again';
                        areWeLoading = false;
                      });
                    }
                    print(email);
                    print(password);
                  }
                },
                color: Colors.orange[300],
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
