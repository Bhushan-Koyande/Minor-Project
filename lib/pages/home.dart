import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/auth.dart';
import 'package:minor_project/models/lab.dart';
import 'package:minor_project/pages/login.dart';
import 'package:minor_project/widgets/labCard.dart';

class HomePage extends StatefulWidget {

  final User user;
  HomePage({this.user});

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
    QuerySnapshot snapshot = await firestoreInstance.collection('LABS').get();
    List<Lab> labs = snapshot.docs.map((doc) => Lab.fromDocument(doc)).toList();
    print(labs.length);
    List<Lab> output = new List();
    for(int i = 0; i < labs.length; i++){
      if(((labs[i].latitude - lat).abs() <= 0.05) && ((labs[i].longitude - long).abs() <= 0.05)){
        output.add(labs[i]);
      }
    }
    print(output.length);
    List<LabCard> l = output.map((val) => LabCard(lab: val, userEmail: widget.user.email,)).toList();
    setState(() {
      labList = l;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 Tests'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountEmail: Text(widget.user.email, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),),
                currentAccountPicture: Icon(Icons.account_circle_sharp, size: 80.0, color: Colors.white70,),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.location_on_rounded),
                title: Text('Containment Zones'),
              ),
              onTap: (){  },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.list_sharp),
                title: Text('Statistics'),
              ),
              onTap: (){  },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sign Out'),
              ),
              onTap: (){
                authHandler.handleSignOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: labList,
      ),
    );
  }
}