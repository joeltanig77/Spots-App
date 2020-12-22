import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  // Reference our service class
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Service _auth = Service();

  GoogleMapController mapController;

  final LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          title: Text(
            "Spots",
          ),
          centerTitle: true,
          backgroundColor: Colors.orange[300],
          // Note, This is actions for the appbar like the log in button
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text("Log out"),
            ),
          ],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),

          myLocationEnabled:true,
        ),
      ),
    );
  }
}
