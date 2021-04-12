import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/activity.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class ProfilePage extends StatefulWidget {

  final User appUser;
  ProfilePage({this.appUser});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FirebaseFirestore instance = FirebaseFirestore.instance;

  List<Activity> activities = new List();
  List<ListTile> l = new List();
  String patientName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addToDisplay();
  }

  void addToDisplay() async {
    await fetchUserDetails();
    activities.sort((a, b) => b.date.compareTo(a.date));
    print(activities.length);
    l = activities.map((activity) => ListTile(title: Text(activity.content),)).toList();
  }

  Future<void> fetchUserDetails() async {
    instance.collection('USERS').where('Email', isEqualTo: widget.appUser.email).get()
        .then((value) {
          patientName = value.docs.first.get('Name');
          print(patientName);
        });
    instance.collection('APPOINTMENTS').where('patient name', isEqualTo: patientName).get()
          .then((value) {
            if(value != null){
                activities.add(Activity(date: '01-01-2021', content: "Test Appointment : at "+value.docs.first.get('lab name')+
                    '\n'+'STATUS-'+value.docs.first.get('status')));
            }
        }).catchError((e){
          print(e);
      });
    instance.collection('TESTS').where('Patient Name', isEqualTo: patientName).get()
          .then((value) {
            if (value != null){
                activities.add(Activity(date: value.docs.first.get('Date'), content: "Test : lab "+value.docs.first.get('Lab ID')+' '+value.docs.first.get('Date')
                    +' '+value.docs.first.get('Time')+'\n'+'RESULT-'+value.docs.first.get('Result')));
            }
      }).catchError((e){
        print(e);
      });
    instance.collection('VACCINE-APPOINTMENTS').where('patient name', isEqualTo: patientName).get()
          .then((value) {
        if (value != null){
            activities.add(Activity(date: value.docs.first.get('Date'), content: "Vaccine Appointment : at "+value.docs.first.get('lab name')
                +' '+value.docs.first.get('Date')+' '+value.docs.first.get('Time')+'\n'+'STATUS-'+value.docs.first.get('status')));
        }
      }).catchError((e){
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: l,
        ),
      ),
    );
  }
}
