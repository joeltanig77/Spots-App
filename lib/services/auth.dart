import 'package:firebase_auth/firebase_auth.dart';
import 'package:spots_app/models/user.dart';


// Team Backend
class Service {
  // Reference the class first
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a user object for the uid
  User _justTheUser(FirebaseUser user) {
    return user != null ? User(uid:user.uid) : null;
  }

  // Listen to sign in and sign out stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _justTheUser(user));
}




  // sign in anon
  Future signInNoAccount() async {
    try {
      AuthResult authResult = await _auth.signInAnonymously();
      FirebaseUser firebaseUser = authResult.user;
      return _justTheUser(firebaseUser);
    }
      catch (e) {
      print(e.toString());
      return null;
    }


  }


// sign in with email and password
  Future signInAccount(String email, String password) async {
    try{
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _justTheUser(firebaseUser);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }




// register account
  Future registerAccount(String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _justTheUser(firebaseUser);
    }
    catch(e) {
        print(e.toString());
        return null;
    }
  }





// sign out
  Future signOut() async{
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
}



}
