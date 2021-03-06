import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/models/test.dart';
import 'package:minor_project/pages/testDetail.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class LabTestsPage extends StatefulWidget {

  final String id;

  LabTestsPage({this.id});

  @override
  _LabTestsPageState createState() => _LabTestsPageState();
}

class _LabTestsPageState extends State<LabTestsPage> {

  FirebaseFirestore instance = FirebaseFirestore.instance;
  bool isEmpty = true;
  List<ListTile> testList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTestsData();
  }

  void getTestsData() {
    instance.collection('TESTS').where('Lab ID', isEqualTo: widget.id).get()
        .then((value) {
          List<Test> tests = value.docs.map((doc) => Test.fromDocument(doc)).toList();
          tests.removeWhere((element) => element.result != 'TBC');
          List<ListTile> l = tests.map((test) =>
            ListTile(
              title: Text('NAME : ${test.patientName}'),
              subtitle: Text('Appointment Id : ${test.appointmentId}'),
              onTap: () async {
                String result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TestDetailPage(t: test,)));
                if(result == 'updated'){
                  getTestsData();
                }
              },
            ),
          ).toList();
          setState(() {
            testList = l;
            isEmpty = l.isEmpty;
          });
        }).catchError((e){
          print(e);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allotted Tests'),
        centerTitle: true,
      ),
      body: Container(
        child: isEmpty != true ? ListView(
          children: testList,
        ):
        Center(
          child: Text('No tests'),
        ),
      )
    );
  }
}
