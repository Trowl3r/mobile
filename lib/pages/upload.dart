  
import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
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
      body: Text("Upload")
    );
  }
}