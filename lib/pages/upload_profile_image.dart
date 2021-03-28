import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hononym/pages/home.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

class UploadProfileImage extends StatefulWidget {
  @override
  _UploadProfileImageState createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  bool isUploading = false;
  String base64Image;

  handleTakePhoto() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Make a Profile Image"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Photo with Camera"),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text("Image from Gallery"),
              onPressed: handleChooseFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  uploadImage() async {
    if (file == null) return;

    var request = http.MultipartRequest(
        "PUT", Uri.parse("http://192.168.2.110:5000/api/users/change-pb"));
    request.headers['x-auth-token'] = await storage.read(key: "token");

    var pic = await http.MultipartFile.fromPath("image", file.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode != 200) {
      SnackBar snackBar = SnackBar(
        content: Text(response.reasonPhrase),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  handleSubmit() async {
    if (file == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      setState(() {
        isUploading = true;
      });
      uploadImage();
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            isUploading
                ? Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  )
                : Text(""),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Center(
                child: Text(
                  "Provide a Profile Image",
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 200.0, 0, 50.0),
              child: GestureDetector(
                child: CircleAvatar(
                  radius: 100.0,
                  backgroundImage: file == null
                      ? NetworkImage('https://via.placeholder.com/150')
                      : FileImage(file),
                ),
                onTap: () => selectImage(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: uploadImage,
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
