import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hononym/models/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class Post extends StatefulWidget {
  //TDOO: Make the Post class, and then make a post widget with all functions (like delete comment etc). then make a special widget folder where the style is created.
// When I need those widgets, I will then get them in the screen where they are needed, and then give them to the widgets folder widget.

  final String id;
  final String user;
  final String postImage;
  final String text;
  final List likes;
  final List comments;
  final bool isGroupPost;
  final String group;
  final String date;

  Post(
      {this.id,
      this.user,
      this.postImage,
      this.text,
      this.likes,
      this.comments,
      this.isGroupPost,
      this.group,
      this.date});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
        id: json['id'],
        user: json['user'],
        postImage: json['postImage'],
        text: json['text'],
        likes: json['likes'],
        comments: json['comments'],
        isGroupPost: json['isGroupPost'],
        group: json['group'],
        date: json['date']);
  }

  @override
  _PostState createState() => _PostState(
      id: this.id,
      user: this.user,
      postImage: this.postImage,
      text: this.text,
      likes: this.likes,
      comments: this.comments,
      isGroupPost: this.isGroupPost,
      group: this.group,
      date: this.date);
}

final storage = new FlutterSecureStorage();

class _PostState extends State<Post> {
  final String id;
  final String user;
  final String postImage;
  final String text;
  final List likes;
  final List comments;
  final bool isGroupPost;
  final String group;
  final String date;
  User currentUser;
  User postUser;

  @override
  void initState() {
    super.initState();
    handleUser();
    getPostUser();
    handleUser();
  }

  _PostState(
      {this.id,
      this.user,
      this.postImage,
      this.text,
      this.likes,
      this.comments,
      this.isGroupPost,
      this.group,
      this.date});

  Future getPost() {}

  getPostUser() async {
    final response = await http.get(
        Uri.http("192.168.2.110:5000", "/api/users/user/" + user),
        headers: <String, String>{
          'x-auth-token': await storage.read(key: "token")
        });

    Map<String, dynamic> res = jsonDecode(response.body);
    setState(() {
      postUser = User.fromJson(res);
    });
  }

  handleUser() async {
    final response = await http.get(
        Uri.http("192.168.2.110:5000", "/api/users/user"),
        headers: <String, String>{
          'x-auth-token': await storage.read(key: "token")
        });

    Map<String, dynamic> res = jsonDecode(response.body);
    setState(() {
      currentUser = User.fromJson(res);
    });
  }

  buildPostHeader() {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(thickness: 1.7, height: 1),
          ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  'http://192.168.2.110:5000/profiles/' +
                      postUser.profileImage),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              onTap: () => print("Hello World"),
              child: Text(
                postUser.username,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: currentUser.id == postUser.id
                ? IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () => print("Hello World"),
                  )
                : Text(''),
          ),
        ],
      ),
    );
  }

  Container displaySnackBar() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColorDark),
      ),
    );
  }

  buildMain() {
    return postImage == ""
        ? Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              text,
            ),
          )
        : Container(
            child: Column(
              children: [
                FittedBox(
                  child: Image(
                    image: NetworkImage(
                        'http://192.168.2.110:5000/posts/' + postImage),
                  ),
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Text(
                    text,
                  ),
                )
              ],
            ),
          );
  }

  bool isLiked() {
    print(likes);
    return false;
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: GestureDetector(
                onTap: () => print("Liked"),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 30.0,
                ),
              )),
          title: Text(likes.length.toString() + " likes"),
          trailing: GestureDetector(
            onTap: () => print("Bookmarked"),
            child: Icon(
              Icons.bookmark_border,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: GestureDetector(
              onTap: () => print("Comments"),
              child: Text(
                "View all " + comments.length.toString() + " Comments",
                style: TextStyle(
                  color: Colors.grey,
                ),
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return postUser != null && currentUser != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPostHeader(),
              Divider(thickness: 1, height: 1),
              buildMain(),
              Divider(
                thickness: 1,
                height: 1,
              ),
              buildPostFooter()
            ],
          )
        : Text("");
  }
}
/* => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,
              )*/
