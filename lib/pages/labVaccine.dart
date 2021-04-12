import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/appointment.dart';
import 'package:minor_project/pages/appointmentDetail.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class LabVaccinesPage extends StatefulWidget {

  final String labId;
  final String labName;

  LabVaccinesPage({this.labId, this.labName});

  @override
  _LabVaccinesPageState createState() => _LabVaccinesPageState();
}

class _LabVaccinesPageState extends State<LabVaccinesPage> {

  bool isEmpty = true;
  List<ListTile> vaccineList = [];

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVaccineAppointments();
  }

  void getVaccineAppointments() async {
    QuerySnapshot querySnapshot = await firestoreInstance.collection('VACCINE-APPOINTMENTS')
        .where('lab name', isEqualTo: widget.labName).get();
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
                        builder: (context) => AppointmentDetailPage(title: 'Vaccine Appointment', labId: widget.labId, a: e,)
                      ));
                      getVaccineAppointments();
                    },
                )
    ).toList();
    setState(() {
      vaccineList = l;
      isEmpty = l.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vaccine Appointments'),
          centerTitle: true,
        ),
        body: Container(
          child: isEmpty != true ? ListView(
            children: vaccineList,
          ):
          Center(
            child: Text('No vaccine appointments'),
          ),
        )
    );
  }
}
