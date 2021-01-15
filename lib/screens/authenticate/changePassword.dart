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
  dynamic result;


  showAlertNoti(BuildContext context) {
    Widget cancelButton = FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        }
    );
    Widget continueButton = FlatButton(
      child: Text('Continue'),
      onPressed: () async {
        result = await _auth.changePassword(password);
        print("Password has been changed");
        Navigator.of(context).pop();
      },
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text(
          'Change Password?'
      ),
      content: Text('Are you sure you want to change your password?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor  = Color(0xffEFE2C8);
    final barColor = Color(0xFF4a6299);
    final gColor1  = Color(0xffd8a156);

    return areWeLoading ? LoadingAnimation() : Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: barColor,
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
                        if(result == null) {
                          error = "Log in again before retrying this request";
                          areWeLoading = false;
                        }
                        showAlertNoti(context);
                        areWeLoading = false;
                        //Snack Bar here
                      }
                    },
                    color: barColor,
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
