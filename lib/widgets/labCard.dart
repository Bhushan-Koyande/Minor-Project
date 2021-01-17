import 'package:flutter/material.dart';
import 'package:minor_project/models/lab.dart';

class LabCard extends StatelessWidget {

  final Lab lab;
  LabCard({@required this.lab});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {  },
        ),
        title: Text(lab.name, style: TextStyle(color: Colors.blue[800]),),
        subtitle: Text('${lab.type} LAB', style: TextStyle(color: Colors.blueGrey[500]),),
      ),
    );
  }
}