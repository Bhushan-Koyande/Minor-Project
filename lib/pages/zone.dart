import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ZonesPage extends StatefulWidget {

  @override
  _ZonesPageState createState() => _ZonesPageState();
}

class _ZonesPageState extends State<ZonesPage> {

  final String apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsSWRlbnRpdHkiOiJhbC5pLnNzLmkuYWJ1Yy5rLm4uZXJ0bS5wQGdtYWlsLmNvbSJ9.RwVUVM4QoF91Knbf9fKGSLXq2hhyj3ZULhQKjto1Z30";
  final String apiUrl = "https://data.geoiq.io/dataapis/v1.0/covid/nearbyzones";

  List <ListTile> zonesList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceLocation();
  }

  void getDeviceLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      print(position.latitude);
      print(position.longitude);
      getContainmentZones(position.latitude, position.longitude);
    }).catchError((e){
      print(e);
    });
  }

  void getContainmentZones(double lat, double long) {
    var body = {
      "key": apiKey,
      "lng": long,
      "lat": lat,
      "radius": 5000
    };
    var header = {'Content-Type': 'application/json'};
    http.post(apiUrl, body: jsonEncode(body), headers: header)
        .then((value) {
          if(value.statusCode == 200){
            print(value.body);
            var response = jsonDecode(value.body);
            List<dynamic> zonesData = response["containmentZoneNames"];
            List<ListTile> l = zonesData.map((e) => ListTile(
              title: Text(e.toString()),
              leading: Icon(Icons.coronavirus_outlined),
              dense: true,
            )).toList();
            setState(() {
              zonesList = l;
            });
          }
    }).catchError((e){
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Containment Zones'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: zonesList,
        ),
      ),
    );
  }
}
