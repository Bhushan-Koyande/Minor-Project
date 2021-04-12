import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/appointment.dart';
import 'package:minor_project/pages/appointmentDetail.dart';
import 'package:minor_project/pages/labCharge.dart';
import 'package:minor_project/pages/labLogin.dart';
import 'package:minor_project/pages/labTest.dart';
import 'package:minor_project/pages/labVaccine.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class LabHomePage extends StatefulWidget {

  final String id;
  final String name;

  LabHomePage({this.id, this.name});

  @override
  _LabHomePageState createState() => _LabHomePageState();
}

class _LabHomePageState extends State<LabHomePage> {

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<ListTile> appointmentList = [];
  bool isEmpty = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointments();
  }

  void getAppointments() async {
    QuerySnapshot querySnapshot = await firestoreInstance.collection('APPOINTMENTS').where('lab name', isEqualTo: widget.name).get();
    print(querySnapshot.toString());
    List<Appointment> appointments = querySnapshot.docs.map((doc) => Appointment.fromDocument(doc)).toList();
    appointments.removeWhere((element) => element.status == 'allotted');
    appointments.sort((a, b)=> a.priority.compareTo(b.priority));
    List<ListTile> l = appointments.map(
            (e) => ListTile(
              title: Text(e.patientName),
              subtitle: Text('PRIORITY : ${e.priority}'),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AppointmentDetailPage(title: 'Test Appointment', labId: widget.id, a: e,)
                ));
                getAppointments();
              },
            )
    ).toList();
    setState(() {
      appointmentList = l;
      isEmpty = l.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Appointments'),
        centerTitle: true,
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
                leading: Icon(Icons.science_outlined),
                title: Text('Tests'),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LabTestsPage(id: widget.id,)));
              },
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.done),
                title: Text('Vaccination'),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LabVaccinesPage(labName: widget.name,)));
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
        child: isEmpty != true ? ListView(
          children: appointmentList,
        ) :
        Center(
          child: Text('No appointments'),
        ),
      ),
    );
  }
}
