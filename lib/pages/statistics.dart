import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minor_project/widgets/stateCard.dart';

class StatisticsPage extends StatefulWidget {

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  final String apiURL = 'https://api.rootnet.in/covid19-in/stats/latest';
  
  var countryData;
  
  List<StateCard> statsList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatisticsData();
  }

  getStatisticsData() {
    http.get(apiURL).then((value) {
      if(value.statusCode == 200){
        var response = jsonDecode(value.body);
        var responseData = response['data'];
        countryData = responseData['summary'];
        List<StateCard> l = new List();
        l.add(StateCard(
          name: 'india'.toUpperCase(),
          confirmed: countryData['total'],
          recovered: countryData['discharged'],
          deceased: countryData['deaths'],
        ));
        print(responseData['regional']);
        List<dynamic> stateData = responseData['regional'];
        List<StateCard> stateList = stateData.map((state) => StateCard(
          name: state['loc'],
          confirmed: state['totalConfirmed'],
          recovered: state['discharged'],
          deceased: state['deaths'],
        )).toList();
        print(stateList.length);
        l.addAll(stateList);
        setState(() {
          statsList = l;
        });
      }
    }).catchError((e){
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 Statistics'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: statsList,
        )
      ),
    );
  }
}
