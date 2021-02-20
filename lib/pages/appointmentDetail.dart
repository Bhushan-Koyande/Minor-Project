import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/appointment.dart';

class AppointmentDetailPage extends StatefulWidget {

  final String title;
  final String labId;
  final Appointment a;

  AppointmentDetailPage({this.title, this.labId, this.a});

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  
  String allottedDate;
  String allottedTime;

  FirebaseFirestore instance = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Patient Name : ${widget.a.patientName}', style: TextStyle(fontSize: 19.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Patient Age : ${widget.a.ageDetail}', style: TextStyle(fontSize: 19.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Patient is a : ${widget.a.professionDetail}', style: TextStyle(fontSize: 19.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Co-morbidity : ${widget.a.comorbidityDetail}', style: TextStyle(fontSize: 19.0),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
              child: TextField(
                style: TextStyle(color: Colors.blue[800]),
                onChanged: (String val){
                  allottedDate = val;
                },
                decoration: InputDecoration(
                  labelText: 'Allot date',
                  hintText: 'Enter date as DD-MM-YYYY',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  hintStyle: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
              child: TextField(
                style: TextStyle(color: Colors.blue[800]),
                onChanged: (String val){
                  allottedTime = val;
                },
                decoration: InputDecoration(
                  labelText: 'Allot time',
                  hintText: 'Enter date in 24hr format',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  hintStyle: TextStyle(color: Colors.blue[700]),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: (){
          if(widget.title == 'Test Appointment'){
            instance.collection('TESTS')
                .add({
              'Lab ID': widget.labId,
              'Patient Name': widget.a.patientName,
              'Appointment ID': widget.a.appointmentId,
              'Date': allottedDate,
              'Time': allottedTime,
              'Result': 'TBC'
            }).then((value) => {
              instance.collection('APPOINTMENTS').doc(widget.a.appointmentId).update({"status": "allotted"})
                  .then((value) {
                print('Test : time allotted');
                Navigator.pop(context);
              })
            }).catchError((e){
              print(e);
            });
          }else if(widget.title == 'Vaccine Appointment'){
            instance.collection('VACCINE-APPOINTMENTS').doc(widget.a.appointmentId)
                .update({"status": "allotted", "Date": allottedDate, "Time": allottedTime})
                .then((value) {
              print('Vaccine : time allotted');
              Navigator.pop(context);
            }).catchError((e){
              print(e);
            });
          }
        },
      ),
    );
  }
}
