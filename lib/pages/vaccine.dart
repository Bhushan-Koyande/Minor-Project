import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minor_project/models/lab.dart';
import 'package:minor_project/widgets/labCard.dart';

class VaccinePage extends StatefulWidget {

  final User currentUser;
  VaccinePage({this.currentUser});

  @override
  _VaccinePageState createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<LabCard> vaccineCenters = [];

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
      getCentersData(position.latitude, position.longitude);
    }).catchError((e){
      print(e);
    });
  }

  void getCentersData(double lat, double long) async {
    QuerySnapshot snapshot = await firestoreInstance.collection('LABS').get();
    List<Lab> labs = snapshot.docs.map((doc) => Lab.fromDocument(doc)).toList();
    print(labs.length);
    List<Lab> output = [];
    for(int i = 0; i < labs.length; i++){
      if(labs[i].type == 'GOVT'){
        if(((labs[i].latitude - lat).abs() <= 0.2) && ((labs[i].longitude - long).abs() <= 0.2)){
          output.add(labs[i]);
        }
      }
    }
    print(output.length);
    List<LabCard> l = output.map((val) => LabCard(lab: val, userEmail: widget.currentUser.email, title: 'Vaccine',)).toList();
    setState(() {
      vaccineCenters = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 Vaccine'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: vaccineCenters,
        ),
      ),
    );
  }
}
