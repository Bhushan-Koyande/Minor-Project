import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';
import 'package:minor_project/pages/home.dart';
import 'package:minor_project/pages/login.dart';

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