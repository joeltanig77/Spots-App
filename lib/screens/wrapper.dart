import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:geolocator/geolocator.dart';
double lat1=0;
double long1=0;
String stealUID;
// Need to add if statement to see if there is a user and if there is go to screens.screens.home screen and if there is not, go to Authenticate page
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    getLocal();
    // We get this value from the Provider stream
    return user == null ? Authenticate() : Home(lat1, long1, user.uid);
  }

  getLocal() async{
    final location = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat1=location.latitude;
    long1=location.longitude;
    return location;
  }
}
