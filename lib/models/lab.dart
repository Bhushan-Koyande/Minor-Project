import 'package:cloud_firestore/cloud_firestore.dart';

class Lab {

  final String labId;
  final String name;
  final double latitude;
  final double longitude;
  final String type;

  Lab({this.labId, this.name, this.latitude, this.longitude, this.type});

  factory Lab.fromDocument(DocumentSnapshot doc){
    return Lab(
        labId: doc.id,
        name: doc['NAME'],
        latitude: doc['LAT'],
        longitude: doc['LONG'],
        type: doc['TYPE'] ? 'GOVT' : 'PRIVATE'
    );
  }
}