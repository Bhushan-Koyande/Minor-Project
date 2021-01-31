import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/test.dart';

class LabCharges extends StatefulWidget {

  final String labId;

  LabCharges({this.labId});

  @override
  _LabChargesState createState() => _LabChargesState();
}

class _LabChargesState extends State<LabCharges> {

  double charges = 0.0;
  int testCount = 0;
  int positiveCount = 0;
  int negativeCount = 0;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLabStatistics();
  }

  void getLabStatistics() {
    firestoreInstance.collection("TESTS").where("Lab Id", isEqualTo: widget.labId).get()
        .then((value) {
      List<Test> tests = value.docs.map((doc) => Test.fromDocument(doc)).toList();
      int a = 0, b = 0;
      tests.map((t) {
        if(t.result == 'positive'){
          a += 1;
        }else if(t.result == 'negative'){
          b+= 1;
        }
      });
      setState(() {
        positiveCount = a;
        negativeCount = b;
        testCount = a + b;
      });
    }).catchError((e){
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Charges'),
      ),
      body: Container(
        child: Center(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('LAB TESTS INFO'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('TOTAL : $testCount'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('+VE   : $positiveCount'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('-VE   : $negativeCount'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
