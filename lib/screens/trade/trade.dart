import 'package:flutter/material.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/locations.dart';

//TODO Someone from ui team plz fix this, only added this widget to have the stream working
class TradePage extends StatefulWidget {
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<List<Location>>(context);

    location.forEach((location) {
      print(location.locationName);
      print(location.lat);
      print(location.long);
      print(location.radius);
    });


    return Container();
  }
}
