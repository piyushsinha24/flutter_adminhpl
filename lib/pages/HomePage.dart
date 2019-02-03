import 'package:flutter/material.dart';

import './AllMatches.dart';
import './AddMatch.dart';
import './Leaderboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Add Match',
              ),
              Tab(
                text: 'All Matches',
              ),
              Tab(
                text: 'LeaderBoard',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[AddMatch(), AllMatches(),LeaderBoard()],
        ),
      ),
    );
  }
}
