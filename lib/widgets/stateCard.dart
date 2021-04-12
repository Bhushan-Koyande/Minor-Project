import 'package:flutter/material.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class StateCard extends StatelessWidget {

  final String name;
  final int confirmed;
  final int recovered;
  final int deceased;

  StateCard({this.name, this.confirmed, this.recovered, this.deceased});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Padding(
              padding: const EdgeInsets.only(top:12.0),
              child: Text('$name', style: TextStyle(color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:12.0),
              child: Text('CONFIRMED            $confirmed', style: TextStyle(color: Colors.blue),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:12.0),
              child: Text('RECOVERED            $recovered', style: TextStyle(color: Colors.green),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:12.0, bottom:12.0),
              child: Text('DECEASED             $deceased', style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ),
    );
  }
}
