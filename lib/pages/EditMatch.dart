import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/MatchModel.dart';

class EditMatch extends StatefulWidget {
  final MatchModel match;
  EditMatch(this.match);

  @override
  _EditMatchState createState() => _EditMatchState();
}

class _EditMatchState extends State<EditMatch> {
  TextEditingController _firstScore, _secondScore;

  @override
  void initState() {
    super.initState();
    _firstScore = TextEditingController();
    _secondScore = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Match'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: Text(
              '${widget.match.firstTeam}  vs  ${widget.match.secondTeam}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _firstScore,
              decoration: InputDecoration(labelText: 'First Team Score'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _secondScore,
              decoration: InputDecoration(labelText: 'Second Team Score'),
            ),
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () => _submitData(context, 0),
          ),
          widget.match.status == 0
              ? Container()
              : RaisedButton(
                  child: Text("Mark as Today's match"),
                  onPressed: () => _submitData(context, 1),
                )
        ],
      ),
    );
  }

  void _submitData(BuildContext context, int statusCode) {
    final Map<String, dynamic> matchData = {
      'firstTeam': widget.match.firstTeam,
      'secondTeam': widget.match.secondTeam,
      'firstScore': statusCode == 0 ? _firstScore.text : null,
      'secondScore': statusCode == 0 ? _secondScore.text : null,
      'status': statusCode
    };

    http
        .put(
            'https://hplapp-705d6.firebaseio.com/schedule/${widget.match.matchId}.json',
            body: json.encode(matchData))
        .then((http.Response response) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Updated Successfully'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    _firstScore.text = '';
                    _secondScore.text = '';
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    });
  }
}
