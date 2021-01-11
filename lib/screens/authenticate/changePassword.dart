import 'package:flutter/material.dart';
import 'package:spots_app/const/loading.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/const/sharedStyles.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

//await _auth.changePassword(password)

class _ChangePasswordState extends State<ChangePassword> {
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
                      validator: (val) => val.isEmpty ? 'Enter a password' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val.trim();
                        });
                      },
                      decoration: textInputStyle.copyWith(labelText: "New Password"),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(color:Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          areWeLoading = true;
                        });
                        // Futures always await
                        dynamic resultFromResetPassword = await _auth.changePassword(password);
                        if(resultFromResetPassword == null){
                          setState(() {
                            areWeLoading = false;
                          });
                        }
                        print("Password has been changed");
                        //Snack Bar here
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
