import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/pages/news.dart';
import 'package:minor_project/services/auth.dart';
import 'package:minor_project/models/lab.dart';
import 'package:minor_project/pages/login.dart';
import 'package:minor_project/pages/statistics.dart';
import 'package:minor_project/pages/vaccine.dart';
import 'package:minor_project/pages/zone.dart';
import 'package:minor_project/widgets/labCard.dart';
import 'package:http/http.dart' as http;

//Flutter - version 2.0.3
//Dart - version 2.12.2

class HomePage extends StatefulWidget {

  final User user;
  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var authHandler = Auth();
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<LabCard> labList = [];
  var notification;

  final String apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsSWRlbnRpdHkiOiJhbC5pLnNzLmkuYWJ1Yy5rLm4uZXJ0bS5wQGdtYWlsLmNvbSJ9.RwVUVM4QoF91Knbf9fKGSLXq2hhyj3ZULhQKjto1Z30";
  final String apiUrl = "https://data.geoiq.io/dataapis/v1.0/covid/locationcheck";

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var androidDetails = new AndroidNotificationDetails(
      "Channel ID", "Minor Project", "Minor Project Semester 6",importance: Importance.max);
  var iOSDetails = new IOSNotificationDetails();
  var generalNotificationDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceLocation();

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    generalNotificationDetails = new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    getNotified();

  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Important !"),
        content: Text("$payload"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
        elevation: 5.0,
      ),
    );
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
            if (notification != null){
              String content = "You have a test at lab no."+notification["Lab ID"]+" on "+notification["Date"]+" at "+notification["Time"];
              DateTime testDate = DateTime.parse(notification["Date"].toString());
              if(testDate.isAfter(DateTime.now())){
                flutterLocalNotificationsPlugin.show(2, "Minor Project", content, generalNotificationDetails, payload: content);
              }
            }
      });
      firestoreInstance.collection("VACCINE-APPOINTMENTS").where('patient name', isEqualTo: name).get()
          .then((value) {
        print(value.docs);
        setState(() {
          notification = value.docs.first;
        });
        if (notification != null){
          String content = "Vaccination at "+notification["lab name"]+" on "+notification["Date"]+" at "+notification["Time"]
              +" and "+notification["Next"]+" at "+notification["Time"];
          DateTime vaccineDate = DateTime.parse(notification["Next"].toString());
          if(vaccineDate.isAfter(DateTime.now())){
            flutterLocalNotificationsPlugin.show(0, "Minor Project", content, generalNotificationDetails, payload: content);
          }
        }
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
      isContainmentZone(position.latitude, position.longitude);
    }).catchError((e){
      print(e);
    });
  }
  
  void getLabsData(double lat, double long) async {
    QuerySnapshot snapshot = await firestoreInstance.collection('LABS').get();
    List<Lab> labs = snapshot.docs.map((doc) => Lab.fromDocument(doc)).toList();
    print(labs.length);
    List<Lab> output = [];
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

  void isContainmentZone(double lat, double long){
    var body = {
    "latlngs": [[
      lat,
      long
    ]],
      "key": apiKey,
    };
    var header = {'Content-Type': 'application/json'};
    http.post(apiUrl, body: jsonEncode(body), headers: header)
        .then((value) {
          if(value.statusCode == 200){
            var response = jsonDecode(value.body);
            List<dynamic> values = response["data"];
            var obj = values[0];
            print(obj["inContainmentZone"]);
            if(obj["inContainmentZone"] == true){
              String content = "You are in a Containment Zone";
              flutterLocalNotificationsPlugin.show(1, "Minor Project", content, generalNotificationDetails, payload: content);
            }else if(obj["inContainmentZone"] == false){
              String content = "You are not in a Containment Zone";
              flutterLocalNotificationsPlugin.show(1, "Minor Project", content, generalNotificationDetails, payload: content);
            }
          }
    }).catchError((e){
      print(e);
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ZonesPage()));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.view_headline_sharp),
                title: Text('News'),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage()));
              },
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