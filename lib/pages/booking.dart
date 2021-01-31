import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {

  final String labName;
  final String patientEmail;

  BookingPage({this.labName, this.patientEmail});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  String professionDetail = '';
  String ageDetail = '';
  int priority = 0;
  String isComorbid = '';
  String comorbidityDetails = '';

  FirebaseFirestore instance = FirebaseFirestore.instance;
  var userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instance.collection('USERS').where("Email", isEqualTo: widget.patientEmail).get()
        .then((value) {
      if(value.docs.length != 0){
        print(value.docs[0]);
        setState(() {
          userData = value.docs[0];
        });
      }else{
        print('An error !');
      }
    }).catchError((e) {
      print(e);
    });
  }

  void bookAppointment() {
    if((professionDetail != '') && (ageDetail != '') && (isComorbid != '') && (comorbidityDetails != '')){
      if(professionDetail == 'doctor'){
        priority = 1;
      }else if(professionDetail == 'health worker'){
        priority = 2;
      }else if(professionDetail == 'govt servant'){
        priority = 3;
      }else if(professionDetail == 'other'){
        if(ageDetail == '>65'){
          priority = 4;
        }else if(ageDetail == '50-65'){
          priority = 5;
        }else if(ageDetail == '<50'){
          if(isComorbid == 'yes'){
            priority = 6;
          }else if(isComorbid == 'no'){
            priority = 7;
          }
        }
      }
      instance.collection('APPOINTMENTS')
          .add({
        'patient name': userData['Name'],
        'priority': priority,
        'profession detail': professionDetail,
        'age detail': ageDetail,
        'comorbid': isComorbid,
        'comorbidity detail': comorbidityDetails,
        'lab name': widget.labName,
        'status': 'pending'
      }).then((value){
        if(value.id != null){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('All details saved !')));
        }
      }).catchError((e){
        print(e);
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }else{
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter all details !')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                children: <Widget>[
                  Text('Profession', style: TextStyle(fontSize: 23, color: Colors.blue[600]),),
                  RadioListTile(
                    groupValue: professionDetail,
                    title: Text('DOCTOR', style: TextStyle(color: Colors.blue[800]),),
                    value: 'doctor',
                    onChanged: (val) {
                      setState(() {
                        professionDetail = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: professionDetail,
                    title: Text('HEALTH WORKER', style: TextStyle(color: Colors.blue[800]),),
                    value: 'health worker',
                    onChanged: (val) {
                      setState(() {
                        professionDetail = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: professionDetail,
                    title: Text('GOVT SERVANT', style: TextStyle(color: Colors.blue[800]),),
                    value: 'govt servant',
                    onChanged: (val) {
                      setState(() {
                        professionDetail = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: professionDetail,
                    title: Text('OTHER', style: TextStyle(color: Colors.blue[800]),),
                    value: 'other',
                    onChanged: (val) {
                      setState(() {
                        professionDetail = val;
                      });
                    },
                  ),
                  Text('$professionDetail', style: TextStyle(fontSize: 23, color: Colors.blue[400]),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                children: <Widget>[
                  Text('Age Group', style: TextStyle(fontSize: 23, color: Colors.blue[600]),),
                  RadioListTile(
                    groupValue: ageDetail,
                    title: Text('65 and above', style: TextStyle(color: Colors.blue[800]),),
                    value: '>65',
                    onChanged: (val) {
                      setState(() {
                        ageDetail = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: professionDetail,
                    title: Text('5O to 65', style: TextStyle(color: Colors.blue[800]),),
                    value: '50-65',
                    onChanged: (val) {
                      setState(() {
                        ageDetail = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: professionDetail,
                    title: Text('Below 50', style: TextStyle(color: Colors.blue[800]),),
                    value: '<50',
                    onChanged: (val) {
                      setState(() {
                        ageDetail = val;
                      });
                    },
                  ),
                  Text('$ageDetail', style: TextStyle(fontSize: 23, color: Colors.blue[400]),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                children: <Widget>[
                  Text('Co-morbidity', style: TextStyle(fontSize: 23, color: Colors.blue[600]),),
                  RadioListTile(
                    groupValue: isComorbid,
                    title: Text('YES', style: TextStyle(color: Colors.blue[800]),),
                    value: 'yes',
                    onChanged: (val) {
                      setState(() {
                        isComorbid = val;
                      });
                    },
                  ),
                  RadioListTile(
                    groupValue: isComorbid,
                    title: Text('NO', style: TextStyle(color: Colors.blue[800]),),
                    value: 'no',
                    onChanged: (val) {
                      setState(() {
                        isComorbid = val;
                      });
                    },
                  ),
                  Text('$isComorbid', style: TextStyle(fontSize: 23, color: Colors.blue[400]),)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
              child: TextField(
                maxLines: 3,
                style: TextStyle(color: Colors.blue[800]),
                onChanged: (String val){
                  comorbidityDetails = val;
                },
                decoration: InputDecoration(
                  labelText: 'Enter co-morbidity details',
                  helperText: 'Enter None if no co-morbidity',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  helperStyle: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          bookAppointment();
        },
        child: Icon(Icons.add),
        tooltip: 'Click to Submit !',
      ),
    );
  }
}
