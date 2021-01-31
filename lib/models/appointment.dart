import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment{

  final String appointmentId;
  final String patientName;
  final int priority;
  final String labName;
  final String professionDetail;
  final String ageDetail;
  final String isComorbid;
  final String comorbidityDetail;
  final String status;

  Appointment({this.appointmentId ,this.patientName, this.priority, this.labName,
    this.professionDetail, this.ageDetail, this.isComorbid, this.comorbidityDetail, this.status});

  factory Appointment.fromDocument(DocumentSnapshot doc){
    return Appointment(
      appointmentId: doc.id,
      patientName: doc['patient name'],
      priority: doc['priority'],
      labName: doc['lab name'],
      professionDetail: doc['profession detail'],
      ageDetail: doc['age detail'],
      isComorbid: doc['comorbid'],
      comorbidityDetail: doc['comorbidity detail'],
      status: doc['status']
    );
  }

}