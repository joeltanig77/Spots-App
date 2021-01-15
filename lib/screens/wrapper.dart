import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:geolocator/geolocator.dart';

double lat1 = 0;
double long1 = 0;
String stealUID;

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    getLocal();
    // We get this value from the Provider stream, and we pass in the user we are signed in on in the Home() constructor
    return user == null ? Authenticate() : Home(lat1, long1, user.uid);
  }

  getLocal() async {
    final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat1 = location.latitude;
    long1 = location.longitude;
    return location;
  }
}
