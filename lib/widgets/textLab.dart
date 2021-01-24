import 'package:flutter/material.dart';

class TextLab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

      return Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
        child: Container(
          //color: Colors.green,
          height: 200,
          width: 200,
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
              ),
              Center(
                child: Text(
                  'Sign In as a COVID-19 Lab',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  }
}
