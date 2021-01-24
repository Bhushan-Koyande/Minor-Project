import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabCharges extends StatefulWidget {

  final String labId;

  LabCharges({this.labId});

  @override
  _LabChargesState createState() => _LabChargesState();
}

class _LabChargesState extends State<LabCharges> {

  double charges = 0.0;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Charges'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Set/Update Charges',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  helperText: 'COVID-19 Test Charges',
                ),
                onChanged: (String val){
                  charges = num.parse(val).toDouble();
                },
              ),
            ),
            SizedBox(height: 4.0,),
            RaisedButton(
              onPressed: (){
                firestoreInstance.collection('LABS').doc(widget.labId).update({"CHARGES": charges})
                    .then((value) {
                      print('charges updated');
                    }).catchError((e){
                      print(e);
                    });
              },
              color: Colors.blue,
              child: Text('SUBMIT', style: TextStyle(color: Colors.white),),
              padding: EdgeInsets.all(8.0),
            )
          ],
        ),
      ),
    );
  }
}
