import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMatch extends StatefulWidget {
  @override
  _AddMatchState createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {
  TextEditingController _firstTeam, _secondTeam;

  @override
  void initState() {
    super.initState();
    _firstTeam = TextEditingController();
    _secondTeam = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextField(
            controller: _firstTeam,
            decoration: InputDecoration(labelText: 'First Team'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextField(
            controller: _secondTeam,
            decoration: InputDecoration(labelText: 'Second Team'),
          ),
        ),
        RaisedButton(
          child: Text('Submit'),
          onPressed: () => _submitData(context),
        )
      ],
    );
  }

  void _submitData(BuildContext context) {
    String firstTeamName, secondTeamName;
    firstTeamName = _firstTeam.text;
    secondTeamName = _secondTeam.text;

    Map<String, dynamic> matchData = {
      'firstTeam': firstTeamName,
      'secondTeam': secondTeamName,
      'firstScore': null,
      'secondScore': null,
      'status': 2
    };

    http
        .post('https://hplapp-705d6.firebaseio.com/schedule.json',
            body: json.encode(matchData))
        .then((http.Response response) {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Upload Complete'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    _firstTeam.text='';
                    _secondTeam.text='';
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
          context: context);
    });
  }
}
