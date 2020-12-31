import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spots_app/screens/profile/profile.dart';
import 'package:spots_app/screens/trade/trade.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spots_app/models/locations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:spots_app/services/markerDatabase.dart';
import 'package:spots_app/models/locations.dart';


double long=-75.7009;
double lat=45.4236;
int count=0;
bool isDragable=true;
bool activeMarker=false;
Map<int, Location> markerz = <int, Location>{};
List<Marker> userMarkers = [];
List<LatLng> coords = [];
List<Location> locations=[];
LatLng currentCoords=LatLng(0,0);

class Home extends StatefulWidget {
  double lat=75.7009;
  double long=45.4236;

  Home(latx, laty){
    this.lat= latx;
    this.long=laty;
  }
  // Reference our service class
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  final Service _auth = Service();
  String _mapStyle;
  GoogleMapController mapController;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLocal();
    mapController.setMapStyle(_mapStyle);
    mapController.animateCamera(

      CameraUpdate.newCameraPosition(
        CameraPosition(

            target: LatLng(getLat(), getLong()), zoom: 20.0),
      ),
    );
  }




  @override
  void initState() {
    getLocal();
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }
  //Replaces marker with the same marker but with undraggable property.
  replaceMarker(MarkerId id){
    setState(() {
      String valueOfMarker= id.value;
      int toIntValue = int.parse(valueOfMarker);
      userMarkers[toIntValue]= (Marker(
        markerId: id,
        infoWindow: InfoWindow(
          title: userMarkers[toIntValue].infoWindow.title,
        ),
        draggable: false,

        position: coords[toIntValue],
      ));
    });
  }



  @override
  Widget build(BuildContext context) {
    getLocal();
    setState(() {

      CameraUpdate.newCameraPosition(
        CameraPosition(

            target: LatLng(getLat(), getLong()), zoom: 20.0),
      );
    });


    return MaterialApp(
      home: StreamProvider<List<Location>>.value(
        value: MarkerDatabase().locations,
        child: Scaffold(
          backgroundColor: Colors.amber[100],
          appBar: AppBar(
            backgroundColor: Colors.orange[300],
            // Note, This is actions for the appbar like the log in button

          actions: [
            FlatButton(
              padding:  EdgeInsets.only(right: 60.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => TradePage(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              child: Text(
                  "Trade",
                  style:  TextStyle(
                    color: Colors.white70,
                    fontSize: 20.0,
                  )),
            ),
            FlatButton(
              padding:  EdgeInsets.only(right: 60.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {

              },
              child: Text(
                  "Map",
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
            ),

              FlatButton(
                padding:  EdgeInsets.only(right: 60.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ProfilePage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Text(

                    "Profile",
                    style:  TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    )),
              ),
            ],

          ),

        body: Stack(
            children: [
              GoogleMap(

                  onMapCreated: _onMapCreated,
                  myLocationEnabled:true,
                  markers: Set.from(userMarkers),

                  //zoomControlsEnabled: false,

                  initialCameraPosition: CameraPosition(target: LatLng(getLat(), getLong()), zoom: 11.0),

                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height,
                    child: GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.primaryVelocity > 0) {

                          } else if (details.primaryVelocity < 0) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => ProfilePage(),
                                transitionDuration: Duration(seconds: 0),
                              ),
                            );
                          }
                        }

                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width / 8,
                  height: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity > 0) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => TradePage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        } else if (details.primaryVelocity < 0) {

                        }
                      }
                  ),
                ),
              ),
            ]
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              child: Icon(Icons.add_location),
              backgroundColor: Colors.orange[300],

              onPressed: (){
                currentCoords=LatLng(getLat(), getLong());
                final ident = MarkerId(count.toString());
                setState(() {
                  userMarkers.add(Marker(
                    markerId: MarkerId(count.toString()),
                    infoWindow: InfoWindow(
                      title: count.toString(),
                    ),
                    draggable: true,
                    onDragEnd:((newMarker){ //Updates location after dragging
                      currentCoords=LatLng(newMarker.latitude, newMarker.longitude);
                    }),
                    onTap: () { //This is the "Confirm Button" for now
                      coords.add(currentCoords);
                      _saveLocal(ident);
                      replaceMarker(ident);

                    },
                    position: LatLng(getLat(), getLong()),
                  )
                    ,
                  );

                });
              },
            ),
          ),
        ),
      ),
    )
    );
  }
}



_saveLocal(MarkerId id) {
  String valueOfMarker= id.value;
  int toIntValue = int.parse(valueOfMarker);

  Location locationOfMarker = new Location(
      lat:coords[toIntValue].latitude, long:coords[toIntValue].longitude);
  locations.add(locationOfMarker);



  print(valueOfMarker);
  print(locationOfMarker.lat);
  print(locationOfMarker.long);

  //if (int.parse(garb)==count){
  activeMarker=false;
  isDragable=true;
  if (toIntValue==count){
  count++;}}







getLocal() async{

  final location = await Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  lat=location.latitude;
  long=location.longitude;
  return location;

}

double getLong(){
  getLocal();
  return long;
}

double getLat(){
  getLocal();
  return lat;
}

List<Location> getLocations(){
  return locations;
}


