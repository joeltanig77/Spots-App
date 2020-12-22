import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Geolocation {


  Future<Position> _checkPosition() async {
    bool isLocationSettingOn = true;
    LocationPermission locationPermission;

    isLocationSettingOn = await Geolocator.isLocationServiceEnabled();

    if(!isLocationSettingOn) {
      return Future.error("Location services are off, please turn on location services");
    }

    locationPermission = await Geolocator.checkPermission();

    if(locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission != LocationPermission.whileInUse && locationPermission != LocationPermission.always){
        return Future.error("Location services have been denied");
      }
    }
      return await Geolocator.getCurrentPosition();
  }

  Future<Position> getLocation() async {
    if (_checkPosition()==null){return null;}
    final location = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);


    String Lat = '${location.latitude}';
    String Long = '${location.longitude}';
    print (Lat+" "+Long);
    return location;
    }

    getLongitude(pos){return pos.longitude;}
    getLatitude(pos){return pos.latitude;}
  }
