import 'package:flutter/material.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hononym",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Text("Activity Feed"),
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Activity Feed Item');
  }
}