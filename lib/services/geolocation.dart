import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Geolocation {


  Future<Position> _checkPosition() async {
    bool isLocationSettingOn = true;
    LocationPermission locationPermission;

    isLocationSettingOn = await Geolocator.isLocationServiceEnabled();


    if(!isLocationSettingOn) {
      return null;

    }

    locationPermission = await Geolocator.checkPermission();

    if(locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission != LocationPermission.whileInUse && locationPermission != LocationPermission.always){
        return null;
      }
    }
      return await Geolocator.getCurrentPosition();
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
//    if (_checkPosition() == null) {
//      print("Please enable location services");
//      return null;
//    }

    final location = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String lat = '${location.latitude}';
    String long = '${location.longitude}';

    print ("hamburger ");
    print (lat+" "+long);
    return location;
    }

    getLongitude(pos){return pos.longitude;}
    getLatitude(pos){return pos.latitude;}
  }
