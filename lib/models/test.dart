import 'package:cloud_firestore/cloud_firestore.dart';

class Test {

  final String testId;
  final String labId;
  final String patientName;
  final String appointmentId;
  final String testTime;
  final String testDate;
  final String result;

  Test({this.testId, this.labId, this.patientName, this.appointmentId, this.testDate, this.testTime, this.result});

  factory Test.fromDocument(DocumentSnapshot doc){
    return Test(
        testId: doc.id,
        labId: doc['Lab ID'],
        patientName: doc['Patient Name'],
        appointmentId: doc['Appointment ID'],
        testTime: doc['Time'],
        testDate: doc['Date'],
        result: doc['Result']
    );
  }
}