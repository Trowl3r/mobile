import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hononym/widgets/post.dart';

import 'package:http/http.dart' as http;
import 'package:hononym/models/User.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

final storage = new FlutterSecureStorage();

class _ProfileState extends State<Profile> {
  User currentUser;
  List<Post> posts = [];
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    handleUserandGetPosts();
    print(posts);
  }

  getProfilePosts() async {
    final response = await http.get(
        Uri.http("192.168.2.110:5000", "/api/posts/user/" + currentUser.id),
        headers: <String, String>{
          'x-auth-token': await storage.read(key: "token")
        });

    print(response.body);
    Map<String, dynamic> res = jsonDecode(response.body);
    print(res);
    setState(() {
      isLoading = false;
    });

  }

  handleUserandGetPosts() async {
    final response = await http.get(
        Uri.http("192.168.2.110:5000", "/api/users/user"),
        headers: <String, String>{
          'x-auth-token': await storage.read(key: "token")
        });

    Map<String, dynamic> res = jsonDecode(response.body);
    setState(() {
      currentUser = User.fromJson(res);
    });

    final responsePosts = await http.get(
        Uri.http("192.168.2.110:5000", "/api/posts/user/" + currentUser.id),
        headers: <String, String>{
          'x-auth-token': await storage.read(key: "token")
        });

    print(json.decode(responsePosts.body).runtimeType);
    List<dynamic> postRes = json.decode(responsePosts.body);
    print(postRes);
    setState(() {
      posts = postRes.map((post) => Post.fromJson(post)).toList();
      isLoading = false;
    });
    posts.map((post) => print(post));
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

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            count.toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: function,
        child: Container(
          width: 200.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'http://192.168.2.110:5000/profiles/' +
                        currentUser.profileImage),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCountColumn("Posts", currentUser.posts.length),
                        buildCountColumn(
                            "followers", currentUser.follower.length),
                        buildCountColumn(
                            "following", currentUser.following.length),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildButton(
                          text: "Edit Profile",
                          function: () => print("Hello World"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              currentUser.fullName != null ? currentUser.fullName : "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 2.0),
            child: Text(
              currentUser.bio != null ? currentUser.bio : "",
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  buildMain() {
    return isLoading ? Text("") : Column(children: posts,);
  }

          
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentUser != null ? currentUser.username : "",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontSize: 20.0,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff0095FF),
      ),
      body: RefreshIndicator(
        onRefresh: () => handleUserandGetPosts(),
        child: currentUser != null 
            ? 
            Container(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    buildProfileHeader(),
                    Divider(
                      thickness: 2.0,
                      height: 1,
                    ),
                    buildMain()
                  ],
                ),
              )
            : displaySnackBar(),
      ),
    );
  }
}

//CircleAvatar(backgroundImage: NetworkImage('http://192.168.2.110:5000/' + currentUser.profileImage), radius: 100.0,)
