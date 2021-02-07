import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/auth.dart';
import 'package:minor_project/models/lab.dart';
import 'package:minor_project/pages/login.dart';
import 'package:minor_project/pages/statistics.dart';
import 'package:minor_project/pages/vaccine.dart';
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
  var notification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotified();
    getDeviceLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showNotification();
    });
  }

  void showNotification(){
    if(notification != null){
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("COVID-19 test"),
          content: Text("You have a test on ${notification["Date"]} ${notification["Time"]} at Lab No.${notification["Lab ID"]}"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void getNotified() {
    String name = '';
    firestoreInstance.collection('USERS').where('Email', isEqualTo: widget.user.email).get()
        .then((value) {
      name = value.docs.first.get('Name');
      print('name = $name');
      firestoreInstance.collection("TESTS").where('Patient Name', isEqualTo: name).get()
          .then((value) {
            print(value.docs);
            setState(() {
              notification = value.docs.first;
            });
      });
    }).catchError((e){
      print(e);
    });
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
    List<LabCard> l = output.map((val) => LabCard(lab: val, userEmail: widget.user.email, title: 'Test',)).toList();
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
                accountEmail: Text(widget.user.email,
                  style: TextStyle(color: Colors.white70, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                currentAccountPicture: Icon(Icons.account_circle_sharp, size: 80.0, color: Colors.white70,),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.done),
                title: Text('Vaccination'),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => VaccinePage(currentUser: widget.user,)));
              },
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));
              },
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