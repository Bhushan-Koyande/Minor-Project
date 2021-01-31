import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/auth.dart';
import 'package:minor_project/pages/login.dart';
import 'package:minor_project/widgets/signup.dart';
import 'package:minor_project/widgets/textNew.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String radioItem = '';
  String name = '';
  String age = '';
  String profession = '';
  String email = '';
  String address = '';
  String password = '';

  var authHandler = Auth();
  FirebaseFirestore instance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
        ),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SignUp(),
                        TextNew(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (String val){
                            name = val;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                        fillColor: Colors.lightBlueAccent,
                        labelText: 'Name',
                        hintText: 'Enter full name',
                        labelStyle: TextStyle(
                        color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (String val){
                            email = val;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Email',
                            hintText: 'Enter valid email',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Column(
                        children: <Widget>[

                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('MALE', style: TextStyle(color: Colors.white70),),
                            value: 'male',
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                              });
                            },
                          ),

                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('FEMALE', style: TextStyle(color: Colors.white70),),
                            value: 'female',
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                              });
                            },
                          ),

                          Text('$radioItem', style: TextStyle(fontSize: 23, color: Colors.white70),)

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxLines: 5,
                          onChanged: (String val){
                            address = val;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Address',
                            hintText: 'Enter complete address',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (String val){
                            profession = val;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Profession',
                            hintText: 'Enter correct info',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (String val){
                            age = val;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Age',
                            hintText: 'Enter correct age',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (String val){
                            password = val;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Minimum 6 characters',
                            border: InputBorder.none,
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue[300],
                                blurRadius: 10.0, // has the effect of softening the shadow
                                spreadRadius: 1.0, // has the effect of extending the shadow
                                offset: Offset(
                                  5.0, // horizontal, move right 10
                                  5.0, // vertical, move down 10
                                ),
                              ),
                            ],
                            color: Colors.white, borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          onPressed: (){
                            if((email != '') && (password != '') && (name != '') && (age != '')
                                && (profession != '') && (radioItem != '') && (address != '')) {
                              var firebaseUser = authHandler.handleSignUp(email, password);
                              if(firebaseUser != null){
                                instance.collection('USERS').add({
                                  'Name' : name,
                                  'Age' : age,
                                  'Gender' : radioItem,
                                  'Profession' : profession,
                                  'Address' : address,
                                  'Email' : email,
                                });
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              }else{
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error !!! try again')));
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'SIGN UP',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 30),
                      child: Container(
                        alignment: Alignment.topRight,
                        //color: Colors.red,
                        height: 20,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Registered ?',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
