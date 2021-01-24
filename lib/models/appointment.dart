import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment{

  final String patientName;
  final int priority;
  final String labName;
  final String professionDetail;
  final String ageDetail;
  final String isComorbid;
  final String comorbidityDetail;

  Appointment({this.patientName, this.priority, this.labName, this.professionDetail, this.ageDetail, this.isComorbid, this.comorbidityDetail});

  factory Appointment.fromDocument(DocumentSnapshot doc){
    return Appointment(
      patientName: doc['patient name'],
      priority: doc['priority'],
      labName: doc['lab name'],
      professionDetail: doc['profession detail'],
      ageDetail: doc['age detail'],
      isComorbid: doc['comorbid'],
      comorbidityDetail: doc['comorbidity detail']
    );
  }

}