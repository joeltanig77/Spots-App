import 'package:flutter/material.dart';
import 'package:spots_app/const/loading.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/const/sharedStyles.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String error = '';
  String email = "";
  String password = "";
  final Service _auth = Service();
  final _formKey = GlobalKey<FormState>();
  bool areWeLoading = false;



  Widget snackBarrr (BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
          "The email link for a password reset has been sent"
      ),
      duration: Duration(
        seconds: 8
      ),
    );
    //TODO: Turn this on at the end
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }


  @override
  Widget build(BuildContext context) {
    return areWeLoading ? LoadingAnimation() : Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text("Reset Password"),
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
                  RaisedButton.icon(
                    icon: Icon(Icons.email),
                    label: Text(
                      "Reset Password",
                      style: TextStyle(color:Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          areWeLoading = true;
                        });
                        // Futures always await
                        dynamic resultFromResetPassword = await _auth.resetPassword(email);
                        if(resultFromResetPassword == null){
                          setState(() {
                            areWeLoading = false;
                          });
                        }
                        //Snack Bar here
                          snackBarrr(context);
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
        ],
      ),
    );
  }
}

