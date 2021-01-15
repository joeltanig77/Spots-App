import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spots_app/models/userInformation.dart';
import 'package:spots_app/screens/authenticate/register.dart';
import 'package:spots_app/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spots_app/screens/profile/profile.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:spots_app/models/locations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:spots_app/services/markerDatabase.dart';
import 'package:spots_app/models/locations.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/screens/home/trade.dart';
import 'package:spots_app/services/userInformationDatabase.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

FirebaseStorage imageDatabase = FirebaseStorage.instance;

double long = -75.7009;
double lat = 45.4236;
int count = 0;

bool activeMarker = false;

List<Marker> userMarkers = [];
List<LatLng> coords = [];
LatLng currentCoords = LatLng(0, 0);
User usz = User();
String myId = "";
String desc = "";
String locationName = "";
TextEditingController _textController = new TextEditingController();
TextEditingController _textController2 = new TextEditingController();
FloatingSearchBarController _searchcontroller =
    new FloatingSearchBarController();
List<Marker> cloudMarkers = [];
String user;
String bio;
File userImage;
String currentImageUrl =
    "https://firebasestorage.googleapis.com/v0/b/spots-80f7d.appspot.com/o/B9gKstPz8QWQ6EIwg6fRFqzajFw1%2Fpot?alt=media&token=defe9bdd-7124-4f10-b378-c18db7731684";
String searchQuery;
List<String> queryLocations = [];
var queryList = List<Widget>();
int tempLen = 0;

class Home extends StatefulWidget {
  double lat = 75.7009;
  double long = 45.4236;
  String ide = ""; //The users identification

  Home(latx, laty, uidd) {
    this.lat = latx;
    this.long = laty;
    this.ide = uidd;
    myId = this.ide;
  }
  // Reference our service class
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor pinLocationIcon;

  final Service _auth = Service();

  String _mapStyle;
  GoogleMapController mapController;

  double pinPillPosition = -250;

  double finishedPillPosition = -250;

  void _onMapCreated(GoogleMapController controller) {
    currentUser();
    mapController = controller;
    getLocal();
    mapController.setMapStyle(_mapStyle);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(getLat(), getLong()), zoom: 20.0),
      ),
    );
  }

  @override
  void initState() {
    getLocal();
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker4.png')
        .then((icon) {
      pinLocationIcon = icon;
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    getCurrentMarkers();
  }

  void getCurrentMarkers() async {
    final QuerySnapshot snapCheck = await Firestore.instance
        .collection('Coordinates')
        .document(myId)
        .collection("User_Locations")
        .getDocuments();

    List<DocumentSnapshot> garbo = snapCheck.documents;

    garbo.forEach((element) {
      coords.add(LatLng(element.data["lat"], element.data["long"]));

      MarkerId theMarkerId = MarkerId(element.data["locationName"]);
      String otherDesc = element.data["desc"];
      String otherUrl = element.data["url"];
      setState(() {
        //change the marker id property to a iny
        userMarkers.add(Marker(
          markerId: theMarkerId,
          onTap: () {
            if (!activeMarker) {
              locationName = theMarkerId.value;
              desc = otherDesc;
              currentImageUrl = otherUrl;
              setState(() {
                finishedPillPosition = 85;
              });
            }
          },
          infoWindow: InfoWindow(
            title: element.data["locationName"],
          ),
          draggable: false,
          icon: pinLocationIcon,
          position: LatLng(element.data["lat"], element.data["long"]),
        ));
        count++;
      });
    });
  }

  Future<int> getMarkersFromSearch() async {
    final QuerySnapshot snapCheck = await Firestore.instance
        .collection('Coordinates')
        .document(myId)
        .collection("User_Locations")
        .getDocuments();
    List<String> queryLocations = [];
    List<DocumentSnapshot> garbo = snapCheck.documents;

    garbo.forEach((element) {
      int currLength = searchQuery.length;
      String locationNamez = (element.data["locationName"]);

      if (locationNamez.length >= currLength) {
        if (locationNamez.substring(0, currLength) == searchQuery) {
          queryLocations.add(locationNamez);
          print('This is from Function' + queryLocations.length.toString());
          print(queryLocations);
        }
      }
    });
    return queryLocations.length;
  }

  Future<List<String>> getMarkersFromSally() async {
    final QuerySnapshot snapCheck = await Firestore.instance
        .collection('Coordinates')
        .document(myId)
        .collection("User_Locations")
        .getDocuments();
    List<String> queryLocations = [];
    List<DocumentSnapshot> garbo = snapCheck.documents;

    garbo.forEach((element) {
      int currLength = searchQuery.length;
      String locationNamez = (element.data["locationName"]);

      if (locationNamez.length >= currLength) {
        if (locationNamez.substring(0, currLength) == searchQuery) {
          queryLocations.add(locationNamez);
          print('This is from Function' + queryLocations.length.toString());
          print(queryLocations);
        }
      }
    });
    return queryLocations;
  }

  int localIterator = 0;
  Future<String> printLocations() async {
    print('This is from print Local ' + tempLen.toString());
    //print(queryLocations.length);
    if ((localIterator == tempLen) && (tempLen != 0)) {
      print('peanut');
      return 'empty';
    }
    if (tempLen == 0) {
      return '';
    }
    print(queryLocations[localIterator]);
    return queryLocations[localIterator++];
  }

  Future<List<Widget>> searchResults() async {
    final QuerySnapshot snapCheck = await Firestore.instance
        .collection('Coordinates')
        .document(myId)
        .collection("User_Locations")
        .getDocuments();
    List<DocumentSnapshot> garbo = snapCheck.documents;
    for (int i = 0; i < queryLocations.length; i++) {
      var element = garbo[i];
      MarkerId theMarkerId = MarkerId(element.data["locationName"]);
      String otherDesc = element.data["desc"];
      String otherUrl = element.data["url"];

      queryList.add(FlatButton(
        child: Text(queryLocations[i]),
        onPressed: () {
          setState(() {
            if (!activeMarker) {
              locationName = theMarkerId.value;
              desc = otherDesc;
              currentImageUrl = otherUrl;
              //Update the camera
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(element.data["lat"], element.data["long"]),
                    zoom: 20.0),
              ));
            }

            //Open the Location cardview
            finishedPillPosition = 85;
            //Should close the search bar dropdown

            //Empty the query
            queryList = [];
          });
        },
      ));
    }
    return queryList;
  }

  Future getImageFromGallery() async {
    var locationImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    userImage = File(locationImage.path);
    String currentPath = myId + '/' + locationName;

    if (locationImage != null) {
      await imageDatabase
          .ref()
          .child(currentPath)
          .putFile(userImage)
          .onComplete;

      String funTimes =
          await (imageDatabase.ref().child(currentPath).getDownloadURL());

      currentImageUrl = funTimes;
    }
  }

  //Replaces marker with the same marker but with undraggable property.
  Future replaceMarker(MarkerId id) async {
    MarkerDatabase garb = MarkerDatabase();

    String valueOfMarker = id.value;
    int toIntValue = int.parse(valueOfMarker);
    id = MarkerId(locationName);

    String otherDesc = desc;
    String otherUrl = currentImageUrl;

    setState(() {
      //change the marker id property to a iny
      userMarkers[toIntValue] = (Marker(
        markerId: id,
        onTap: () {
          if (!activeMarker) {
            locationName = id.value;
            desc = otherDesc;
            currentImageUrl = otherUrl;
            setState(() {
              finishedPillPosition = 85;
            });
          }
        },
        infoWindow: InfoWindow(
          title: locationName,
        ),
        draggable: false,
        icon: pinLocationIcon,
        position: coords[toIntValue],
      ));
    });
    //After we place the marker, update the data!!
    await MarkerDatabase(user: myId).updateData(
        coords[toIntValue].latitude,
        coords[toIntValue].longitude,
        locationName,
        desc,
        0,
        myId,
        currentImageUrl);
  }

/*
  Future storeUserInformation(String bio) async {
    String garb4 = Register().userName;
    await UserInformationDatabase(user: myId).updateData(garb4, bio);
  }
*/

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final TabFontSize = screenSize.width / 19;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    getLocal();
    setState(() {
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(getLat(), getLong()), zoom: 20.0),
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
            Expanded(
              child: Container(
                //color: Colors.blue,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        //padding:  EdgeInsets.only(right: screenSize.width/6.5 ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  TradePage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                        child: Text("Trade",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: TabFontSize,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width / 8),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {},
                        child: Text("Map",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: TabFontSize,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        //padding:  EdgeInsets.only(right: screenSize.width/6.5),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          await currentUser();
                          await currentBio();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ProfilePage(myId, user, bio),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                        child: Text("Profile",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: TabFontSize,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: Set.from(userMarkers),

            //zoomControlsEnabled: false,

            initialCameraPosition:
                CameraPosition(target: LatLng(getLat(), getLong()), zoom: 11.0),
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -250;
                finishedPillPosition = -250;
              });
            },
          ),
          AnimatedPositioned(
            bottom: finishedPillPosition,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                child: Card(
                  color: Colors.amber,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          //finished image
                          Image.network(currentImageUrl),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              color: Colors.amber[600],
                              child: Text(
                                'Name: ' + locationName,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Container(
                              color: Colors.amber[600],
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Description: ' + desc,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: pinPillPosition,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                child: Card(
                  color: Colors.amber,
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          Column(
                            children: [
                              FlatButton(
                                color: Colors.amber[600],
                                height: 70,
                                minWidth: 330,
                                onPressed: () {
                                  getImageFromGallery();
                                },
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Container(
                                  color: Colors.amber[600],
                                  child: TextField(
                                    controller: _textController,
                                    onChanged: (value) {
                                      setState(() {
                                        locationName = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Enter a name for the location'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Container(
                                  color: Colors.amber[600],
                                  height: 50,
                                  child: TextField(
                                    controller: _textController2,
                                    onChanged: (value) {
                                      setState(() {
                                        desc = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Enter a description for the location'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: RaisedButton(
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            if (locationName != "" &&
                                desc != "" &&
                                currentImageUrl != "") {
                              activeMarker = false;

                              final ident = MarkerId(count.toString());

                              coords.add(currentCoords);
                              count++;
                              setState(() {
                                pinPillPosition = -250;
                              });
                              // Turn off the dragable property
                              replaceMarker(ident);
                              _textController.clear();
                              _textController2.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                      pageBuilder: (context, animation1, animation2) =>
                          ProfilePage(myId, user, bio),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                }
              }),
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
                      pageBuilder: (context, animation1, animation2) =>
                          TradePage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                } else if (details.primaryVelocity < 0) {}
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
            child: FloatingSearchBar(
              controller: _searchcontroller,
              onQueryChanged: (value) {
                setState(() async {
                  searchQuery = value;
                  //await getMarkersFromSearch();
                  queryLocations = await getMarkersFromSally();
                  localIterator = 0;
                  queryList = [];
                  queryList = await searchResults();
                  tempLen = await getMarkersFromSearch();
                  print('in widget ' + tempLen.toString());
                  _searchcontroller.close();
                  _searchcontroller.open();
                });
              },

              hint: 'Search...',
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              height: 37,
              maxWidth: isPortrait ? screenSize.width / 2 : 500,
              debounceDelay: const Duration(milliseconds: 500),

              // Specify a custom transition to be used for
              // animating between opened and closed stated.
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(Icons.place),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Row(
                      children: [
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            children: (queryList)),
                        SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              child: Icon(Icons.add_location),
              backgroundColor: Colors.orange[300],
              onPressed: () {
                if (!activeMarker) {
                  currentImageUrl =
                      "https://firebasestorage.googleapis.com/v0/b/spots-80f7d.appspot.com/o/MbAKzrkyoBZo47J6H2CCFulLnWS2%2FMy%20Car?alt=media&token=98c2d877-f983-4848-a544-1d6524ac5b1a";
                  activeMarker = true;
                  locationName = "";
                  desc = "";
                  currentCoords = LatLng(getLat(), getLong());
                  setState(() {
                    userMarkers.add(
                      Marker(
                        markerId: MarkerId(count.toString()),
                        infoWindow: InfoWindow(
                          title: count.toString(),
                        ),
                        icon: pinLocationIcon,
                        draggable: true,
                        onDragEnd: ((newMarker) {
                          //Updates location after dragging
                          currentCoords =
                              LatLng(newMarker.latitude, newMarker.longitude);
                        }),
                        onTap: () {
                          setState(() {
                            pinPillPosition = 85;
                          });
                        },
                        position: LatLng(getLat(), getLong()),
                      ),
                    );
                  });
                }
                ;
              },
            ),
          ),
        ),
      ),
    ));
  }
}

Future getLocal() async {
  final location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  lat = location.latitude;
  long = location.longitude;
  return location;
}

double getLong() {
  getLocal();
  return long;
}

double getLat() {
  getLocal();

  return lat;
}

Future currentUser() async {
  final QuerySnapshot snapCheck = await Firestore.instance
      .collection('User Settings and Data')
      .document(myId)
      .collection("User Info")
      .getDocuments();

  List<DocumentSnapshot> garbo = snapCheck.documents;
  user = garbo[0]["username"];
}

Future currentBio() async {
  final QuerySnapshot snapCheck = await Firestore.instance
      .collection('User Settings and Data')
      .document(myId)
      .collection("User Info")
      .getDocuments();
  List<DocumentSnapshot> garbo = snapCheck.documents;

  bio = garbo[0]["bio"];
}
