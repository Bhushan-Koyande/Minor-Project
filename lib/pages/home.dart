import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/auth.dart';
import 'package:minor_project/models/lab.dart';
import 'package:minor_project/pages/login.dart';
import 'package:minor_project/widgets/labCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var authHandler = Auth();
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<LabCard> labList = List();

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
      getLabsData(position.latitude, position.longitude);
    }).catchError((e){
      print(e);
    });
  }
  
  void getLabsData(double lat, double long) async {
    QuerySnapshot snapshot = await firestoreInstance.collection('LABS').where('LAT', isGreaterThanOrEqualTo: lat)
        .limit(2).get();
    List<LabCard> l = snapshot.docs.map((doc) => LabCard(lab: Lab.fromDocument(doc))).toList();
    setState(() {
      labList = l;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Minor Project'),
      ),
      body: ListView(
        children: labList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authHandler.handleSignOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}