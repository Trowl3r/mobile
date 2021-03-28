import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hononym/models/User.dart';
import 'package:hononym/pages/home.dart';
import 'package:hononym/pages/upload_profile_image.dart';

class CreateUserData extends StatefulWidget {
  @override
  _CreateUserDataState createState() => _CreateUserDataState();
}

User currentUser;

final storage = new FlutterSecureStorage();

class _CreateUserDataState extends State<CreateUserData> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String fullName;
  String bio;

  callRegister() async {
    final response = await http.put(
      Uri.http("192.168.2.110:5000", "/api/users/user-data"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-auth-token': await storage.read(key: "token")
      },
      body: jsonEncode(<String, String>{
        "fullName": fullName,
        "bio": bio,
      }),
    );

    Map<String, dynamic> res = jsonDecode(response.body);
    if (response.statusCode != 200) {
      SnackBar snackBar = SnackBar(
        content: Text(res['msg']),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), () {});
    } else {
      SnackBar snackBar = SnackBar(
        content: Text("You are now Ready!"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), () {});
    }
  }

  submit() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      callRegister();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadProfileImage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Enter Information",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Provide Information so people now you better",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Full Name",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please include you're Full Name";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) => fullName = val,
                              obscureText: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[400]))),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Bio",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please include you're Bio";
                                } else {
                                  return null;
                                }
                              },
                              maxLines: 2,
                              onSaved: (val) => bio = val,
                              obscureText: false,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[400]))),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: submit,
                        color: Color(0xff0095FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Save Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Scaffold(
      key: _scaffoldKey,
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
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Enter some Data",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16),
                        child: Container(
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please include you're Full Name";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => fullName = val,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Tell us you're Full Name",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16),
                        child: Container(
                          child: TextFormField(
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please include you're Bio";
                              } else {
                                return null;
                              }
                            },
                            maxLines: 2,  
                            onSaved: (val) => bio = val,
                            decoration: InputDecoration(
                              labelText: "Bio",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Tell us you're Bio",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ); */
