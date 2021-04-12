import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/test.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class TestDetailPage extends StatefulWidget {

  final Test t;
  TestDetailPage({this.t});

  @override
  _TestDetailPageState createState() => _TestDetailPageState();
}

class _TestDetailPageState extends State<TestDetailPage> {

  FirebaseFirestore instance = FirebaseFirestore.instance;

  String testResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Details'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('Patient Name : ${widget.t.patientName}', style: TextStyle(fontSize: 17.0),),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('Appointment ID : ${widget.t.appointmentId}', style: TextStyle(fontSize: 17.0),),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('Test date : ${widget.t.testDate}', style: TextStyle(fontSize: 17.0),),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('Test time : ${widget.t.testTime}', style: TextStyle(fontSize: 17.0),),
        ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: <Widget>[
                Text('RESULT', style: TextStyle(color: Colors.blue),),
                RadioListTile(
                  groupValue: testResult,
                  title: Text('POSITIVE', style: TextStyle(color: Colors.red),),
                  value: 'positive',
                  onChanged: (val) {
                    setState(() {
                      testResult = val;
                    });
                  },
                ),

                RadioListTile(
                  groupValue: testResult,
                  title: Text('NEGATIVE', style: TextStyle(color: Colors.green),),
                  value: 'negative',
                  onChanged: (val) {
                    setState(() {
                      testResult = val;
                    });
                  },
                ),

                Text('$testResult', style: TextStyle(fontSize: 23, color: Colors.blue),)

              ],
            ),
          )
      ],
    ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          if(testResult != ''){
            instance.collection('TESTS').doc(widget.t.testId).update({"Result": testResult})
                .then((value) {
              print('result updated');
              Navigator.pop(context, 'updated');
            }).catchError((e){
              print(e);
            });
          }
        },
      ),
    );
  }
}
