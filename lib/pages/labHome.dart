import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/appointment.dart';
import 'package:minor_project/pages/labCharge.dart';
import 'package:minor_project/pages/labLogin.dart';

class LabHomePage extends StatefulWidget {

  final String id;
  final String name;

  LabHomePage({this.id, this.name});

  @override
  _LabHomePageState createState() => _LabHomePageState();
}

class _LabHomePageState extends State<LabHomePage> {

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointments();
  }

  void getAppointments() async {
    QuerySnapshot querySnapshot = await firestoreInstance.collection('APPOINTMENTS').where('NAME', isEqualTo: widget.name).get();
    List<Appointment> appointments = querySnapshot.docs.map((doc) => Appointment.fromDocument(doc)).toList();
    appointments.sort((a, b)=> a.priority.compareTo(b.priority));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(widget.name, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),),
                accountEmail: Text('COVID-19 LAB',style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),),
                currentAccountPicture: Icon(Icons.local_hospital_sharp, size: 80.0, color: Colors.white70,),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Test Charges'),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LabCharges(labId: widget.id,)));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sign Out'),
              ),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LabLoginPage()));
              },
            )
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Text('No Appointments'),
        ),
      ),
    );
  }
}
