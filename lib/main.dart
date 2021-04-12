import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';
import 'package:minor_project/pages/home.dart';
import 'package:minor_project/pages/login.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

/*
DATABASE -
COVID-19 Testing Centers data obtained from https://www.icmr.gov.in/
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoggedIn = false;
  User firebaseUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if(firebaseAuth.currentUser != null){
      isLoggedIn = true;
      firebaseUser = firebaseAuth.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minor Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'jost',
      ),
      home: isLoggedIn ? HomePage(user: firebaseUser,) : LoginPage(),
    );
  }
}