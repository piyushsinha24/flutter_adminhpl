import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/MatchModel.dart';
import './EditMatch.dart';

class AllMatches extends StatefulWidget {
  @override
  _AllMatchesState createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches> {
  List<MatchModel> matchList = [];
  bool _fetchingData = true;

  @override
  void initState() {
    super.initState();
    _fetchingData = true;
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMatchList();
  }

  Widget _buildMatchList() {
    if (_fetchingData == false && matchList.length <= 0) {
      return Center(
        child: Text("No matches Found!!"),
      );
    } else if (_fetchingData == false && matchList.length >= 1) {
      return RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildMatchCard(index);
          },
          itemCount: matchList.length,
        ),
        onRefresh: _fetchData,
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildMatchCard(int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(matchList[index].firstTeam,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(matchList[index].firstScore == null
                          ? '---'
                          : matchList[index].firstScore)
                    ],
                  ),
                ),
                Text(
                  'vs',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(matchList[index].secondTeam,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(matchList[index].secondScore == null
                          ? '---'
                          : matchList[index].secondScore),
                    ],
                  ),
                ),
              ],
            ),
          ),
          color: _getCardColor(index),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    EditMatch(matchList[index])));
      },
    );
  }

  Future<Null> _fetchData() {
    matchList.clear();
    return http
        .get('https://hplapp-705d6.firebaseio.com/schedule.json')
        .then((http.Response response) {
      final Map<String, dynamic> matchListData = json.decode(response.body);

      matchListData.forEach((String matchId, dynamic matchData) {
        final MatchModel match = MatchModel(
            matchData['firstTeam'],
            matchData['secondTeam'],
            matchData['firstScore'],
            matchData['secondScore'],
            matchId,
            matchData['status']);

        setState(() {
          matchList.add(match);
          _fetchingData = false;
        });
      });
    });
  }

  Color _getCardColor(int index) {
    if (matchList[index].status == 0)
      return Colors.redAccent;
    else if (matchList[index].status == 1)
      return Colors.greenAccent;
    else
      return Colors.white;
  }
}
