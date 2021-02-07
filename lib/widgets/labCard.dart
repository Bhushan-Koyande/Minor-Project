import 'package:flutter/material.dart';
import 'package:minor_project/models/lab.dart';
import 'package:minor_project/pages/booking.dart';

class LabCard extends StatelessWidget {

  final String title;
  final userEmail;
  final Lab lab;
  LabCard({@required this.lab, @required this.userEmail, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Ink(
          decoration: ShapeDecoration(
            color: Colors.blue[700],
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white,),
            splashColor: Colors.blue[200],
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => BookingPage(labName: lab.name, patientEmail: userEmail, titleText: title,)
              ));
            },
          ),
        ),
        title: Text(lab.name, style: TextStyle(color: Colors.blue[800]),),
        subtitle: Text('${lab.type} LAB         LAB ID : ${lab.labId}', style: TextStyle(color: Colors.blueGrey[500]),),
      ),
    );
  }
}